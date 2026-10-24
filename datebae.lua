local CPS = 5
local TOGGLE_KEY = Enum.KeyCode.V

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")

local enabled = false
local INTERVAL = 1 / CPS

-- Простой статичный индикатор (без мигания)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoClickerStatus"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1
screenGui.Parent = pGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 220, 0, 36)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.BackgroundTransparency = 0.5
statusLabel.BorderSizePixel = 0
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 18
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "Autoclicker: OFF (V)"
statusLabel.Parent = screenGui

-- Автокликер
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

-- Переключение по клавише V
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == TOGGLE_KEY then
        enabled = not enabled
        statusLabel.Text = enabled and "Autoclicker: ON (V)" or "Autoclicker: OFF (V)"
    end
end)
