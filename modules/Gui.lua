local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local ParentContainer = (gethui and gethui()) or game:GetService("CoreGui")

local Screen = Instance.new("ScreenGui", ParentContainer)
Screen.Name = "Shadowly_UI"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 400, 0, 400); Main.Position = UDim2.new(0.5, -200, 0.5, -200); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = _G.SETTINGS.AccentColor

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "SHADOW HUB v11.7"; Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.Font = 3

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, 0, 0, 20); Status.Position = UDim2.new(0,0,0.9,0); Status.Text = "Press INSERT to Toggle Menu"; Status.TextColor3 = Color3.new(0.6,0.6,0.6); Status.BackgroundTransparency = 1

-- Prosty mechanizm zamykania
UIS.InputBegan:Connect(function(i)
    if i.KeyCode == _G.SETTINGS.MenuKey then Main.Visible = not Main.Visible end
end)
