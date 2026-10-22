local CPS = 5
local TOGGLE_KEY = Enum.KeyCode.V

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

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
screenGui.Name = "MaxAdhdOverload"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = pGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1.1, 100, 1.1, 100)
mainFrame.Position = UDim2.new(-0.05, -50, -0.05, -50)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

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
        statusLabel.TextColor3 = Color3.fromHSV(math.random(), 1, 1)
        mainFrame.Position = UDim2.new(-0.05, math.random(-20, 20), -0.05, math.random(-20, 20))
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
        end
    end
end)
