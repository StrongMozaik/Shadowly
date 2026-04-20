local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local ParentContainer = (gethui and gethui()) or game:GetService("CoreGui")

local Screen = Instance.new("ScreenGui", ParentContainer)
Screen.Name = "ShadowElite_UI"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 400, 0, 450); Main.Position = UDim2.new(0.5, -200, 0.5, -225); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = _G.SETTINGS.AccentColor; MainStroke.Thickness = 1.5

local Title = Instance.new("TextLabel", Main)
Title.Text = "  RIVALS | SHADOW ELITE v11.7"; Title.Size = UDim2.new(1, 0, 0, 45); Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tutaj UI steruje _G.SETTINGS (przykład dla przycisku)
local ToggleAim = Instance.new("TextButton", Main)
ToggleAim.Size = UDim2.new(0.9, 0, 0, 35); ToggleAim.Position = UDim2.new(0.05, 0, 0.2, 0); ToggleAim.Text = "Toggle Aimbot"; ToggleAim.MouseButton1Click:Connect(function()
    _G.SETTINGS.AimbotEnabled = not _G.SETTINGS.AimbotEnabled
    ToggleAim.BackgroundColor3 = _G.SETTINGS.AimbotEnabled and _G.SETTINGS.AccentColor or Color3.fromRGB(30,30,30)
end)

-- Ukrywanie menu na INSERT
UIS.InputBegan:Connect(function(i) if i.KeyCode == _G.SETTINGS.MenuKey then Main.Visible = not Main.Visible end end)
