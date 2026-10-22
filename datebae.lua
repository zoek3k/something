local CPS = 5
local TOGGLE_KEY = Enum.KeyCode.V

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local enabled = false
local INTERVAL = 1 / CPS

local player = game:GetService("Players").LocalPlayer
local pGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")

task.spawn(function()
    while true do
        pcall(function()
            game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
            GuiService.MenuIsOpen = false
        end)
        task.wait(0.01)
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraAdhdExplosionOverload"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = pGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(2, 0, 2, 0)
mainFrame.Position = UDim2.new(-0.5, 0, -0.5, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local spinner = Instance.new("Frame")
spinner.Size = UDim2.new(0, 400, 0, 400)
spinner.Position = UDim2.new(0.5, 0, 0.5, 0)
spinner.AnchorPoint = Vector2.new(0.5, 0.5)
spinner.BackgroundTransparency = 0.2
spinner.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0.4, 0)
statusLabel.Position = UDim2.new(0, 0, 0.3, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "ВЫКЛЮЧЕН"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextSize = 130
statusLabel.Font = Enum.Font.LuckiestGuy
statusLabel.ZIndex = 9999
statusLabel.Parent = mainFrame

task.spawn(function()
    while true do
        mainFrame.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
        spinner.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
        statusLabel.TextColor3 = Color3.fromHSV(math.random(), 1, 1)
        
        statusLabel.Position = UDim2.new(0, math.random(-50, 50), 0.3, math.random(-50, 50))
        spinner.Position = UDim2.new(0.5, math.random(-50, 50), 0.5, math.random(-50, 50))
        spinner.Rotation = spinner.Rotation + 35
        
        pcall(function()
            local human = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if human then
                human.CameraOffset = Vector3.new(math.random(-6, 6), math.random(-6, 6), 0)
            end
        end)
        
        RunService.RenderStepped:Wait()
    end
end)

local emojis = {"💀", "🔥", "🤡", "💸", "⚡", "😈", "💥", "👽", "💩", "🚨", "👑", "📈", "👺"}
for i = 1, 60 do
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = emojis[math.random(1, #emojis)]
    label.TextSize = math.random(60, 180)
    label.Size = UDim2.new(0, 200, 0, 200)
    label.Position = UDim2.new(math.random(), 0, math.random(), 0)
    label.TextTransparency = 0.2
    label.Parent = mainFrame

    task.spawn(function()
        local dx = (math.random() - 0.5) * 0.05
        local dy = (math.random() - 0.5) * 0.05
        local rotSpeed = math.random(-30, 30)
        while true do
            local newX = label.Position.X.Scale + dx
            local newY = label.Position.Y.Scale + dy
            if newX < 0.05 or newX > 0.95 then dx = -dx end
            if newY < 0.05 or newY > 0.95 then dy = -dy end
            label.Position = UDim2.new(label.Position.X.Scale + dx, 0, label.Position.Y.Scale + dy, 0)
            label.Rotation = label.Rotation + rotSpeed
            label.TextSize = math.random(60, 180)
            task.wait(0.005)
        end
    end)
end

task.spawn(function()
    while true do
        if enabled then
            pcall(function()
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for i = 1, 3 do
                        local exp = Instance.new("Explosion")
                        exp.BlastRadius = 0
                        exp.BlastPressure = 0
                        exp.DestroyJointRadiusPercent = 0
                        exp.ExplosionType = Enum.ExplosionType.NoCraters
                        
                        local offset = Vector3.new(math.random(-15, 15), math.random(-2, 10), math.random(-15, 15))
                        exp.Position = root.Position + offset
                        exp.Parent = Workspace
                    end
                end
            end)
            task.wait(0.05)
        else
            task.wait(0.2)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if enabled then
        local mousePos = UIS:GetMouseLocation()
        local trail = Instance.new("TextLabel")
        trail.BackgroundTransparency = 1
        trail.Text = "🔥"
        trail.TextSize = math.random(30, 70)
        trail.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y - 36)
        trail.AnchorPoint = Vector2.new(0.5, 0.5)
        trail.Parent = screenGui
        
        task.spawn(function()
            for i = 0, 1, 0.1 do
                trail.TextTransparency = i
                trail.Rotation = trail.Rotation + 15
                task.wait(0.02)
            end
            trail:Destroy()
        end)
    end
end)

task.spawn(function()
    while true do
        if enabled then
            pcall(function()
                local mousePos = UIS:GetMouseLocation()
                VIM:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
                task.wait(0.005)
                VIM:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
            end)
            task.wait(INTERVAL)
        else
            task.wait(0.05)
        end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if input.KeyCode == TOGGLE_KEY then
        enabled = not enabled
        if enabled then
            statusLabel.Text = "ТАПАЕМ ДО ТАЛОГО!!!\nВКЛЮЧЕН"
        else
            statusLabel.Text = "ВЫКЛЮЧЕН"
            pcall(function()
                local human = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if human then human.CameraOffset = Vector3.new(0, 0, 0) end
            end)
        end
    end
end)
