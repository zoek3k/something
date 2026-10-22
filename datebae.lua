local CPS = 5
local TOGGLE_KEY = Enum.KeyCode.V

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local enabled = false
local INTERVAL = 1 / CPS

local player = game:GetService("Players").LocalPlayer
local pGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RgbEpilepsyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = pGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0.3, 0)
statusLabel.Position = UDim2.new(0, 0, 0.35, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "ВЫКЛЮЧЕН"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextSize = 100
statusLabel.Font = Enum.Font.LuckiestGuy
statusLabel.ZIndex = 10
statusLabel.Parent = mainFrame

task.spawn(function()
    while true do
        for i = 0, 1, 0.15 do
            mainFrame.BackgroundColor3 = Color3.fromHSV(i, 1, 1)
            statusLabel.TextColor3 = Color3.fromHSV(1 - i, 1, 1)
            task.wait(0.001)
        end
        mainFrame.BackgroundColor3 = Color3.new(1, 0, 0)
        task.wait(0.001)
        mainFrame.BackgroundColor3 = Color3.new(0, 1, 0)
        task.wait(0.001)
        mainFrame.BackgroundColor3 = Color3.new(0, 0, 1)
        task.wait(0.001)
    end
end)

local emojis = {"💀", "🔥", "🤡", "💸", "⚡", "😈", "💥", "👽"}
for i = 1, 15 do
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = emojis[math.random(1, #emojis)]
    label.TextSize = math.random(50, 120)
    label.Size = UDim2.new(0, 150, 0, 150)
    label.Position = UDim2.new(math.random(), 0, math.random(), 0)
    label.Parent = mainFrame

    task.spawn(function()
        local dx = (math.random() - 0.5) * 0.02
        local dy = (math.random() - 0.5) * 0.02
        local rotSpeed = math.random(-10, 10)
        while true do
            local newX = label.Position.X.Scale + dx
            local newY = label.Position.Y.Scale + dy
            if newX < 0 or newX > 0.95 then dx = -dx end
            if newY < 0 or newY > 0.95 then dy = -dy end
            label.Position = UDim2.new(label.Position.X.Scale + dx, 0, label.Position.Y.Scale + dy, 0)
            label.Rotation = label.Rotation + rotSpeed
            label.TextColor3 = Color3.fromHSV(math.random(), 1, 1)
            task.wait(0.01)
        end
    end)
end

task.spawn(function()
    while true do
        if enabled then
            pcall(function()
                local mousePos = UIS:GetMouseLocation()
                VIM:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
                task.wait(0.01)
                VIM:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
            end)
            task.wait(INTERVAL)
        else
            task.wait(0.1)
        end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == TOGGLE_KEY then
        enabled = not enabled
        if enabled then
            statusLabel.Text = "ТАПАЕТ НА ВСЮ!!!\nВКЛЮЧЕН"
        else
            statusLabel.Text = "ВЫКЛЮЧЕН"
        end
        print("[Автокликер ЛКМ]", enabled and "ВКЛЮЧЕН" or "ВЫКЛЮЧЕН")
    end
end)

print("[Автокликер ЛКМ] Загружен!")
