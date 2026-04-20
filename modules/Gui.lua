local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local ParentContainer = (gethui and gethui()) or game:GetService("CoreGui")

if ParentContainer:FindFirstChild("ShadowElite_UI") then ParentContainer:FindFirstChild("ShadowElite_UI"):Destroy() end

local Screen = Instance.new("ScreenGui", ParentContainer); Screen.Name = "ShadowElite_UI"; Screen.IgnoreGuiInset = true
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 400, 0, 480); Main.Position = UDim2.new(0.5, -200, 0.5, -240); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14); Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = _G.SETTINGS.AccentColor; MainStroke.Thickness = 1.5

local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header); Title.Text = "  RIVALS | SHADOW ELITE v11.8"; Title.Size = UDim2.new(1, 0, 1, 0); Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

local Content = Instance.new("ScrollingFrame", Main); Content.Size = UDim2.new(1, -20, 1, -65); Content.Position = UDim2.new(0, 10, 0, 50); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 0; Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

local function AddToggle(text, key)
    local T = Instance.new("TextButton", Content); T.Size = UDim2.new(1, 0, 0, 38); T.BackgroundColor3 = Color3.fromRGB(20, 20, 24); T.Text = "  " .. text; T.TextColor3 = Color3.fromRGB(180, 180, 180); T.Font = Enum.Font.Gotham; T.TextSize = 13; T.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", T)
    local Ind = Instance.new("Frame", T); Ind.Size = UDim2.new(0, 4, 0, 20); Ind.Position = UDim2.new(0, 0, 0.5, -10); Ind.BackgroundColor3 = _G.SETTINGS[key] and _G.SETTINGS.AccentColor or Color3.fromRGB(40, 40, 40)
    T.MouseButton1Click:Connect(function() _G.SETTINGS[key] = not _G.SETTINGS[key]; TS:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = _G.SETTINGS[key] and _G.SETTINGS.AccentColor or Color3.fromRGB(40, 40, 40)}):Play() end)
end

local function AddSlider(text, min, max, key)
    local SFrame = Instance.new("Frame", Content); SFrame.Size = UDim2.new(1, 0, 0, 50); SFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24); Instance.new("UICorner", SFrame)
    local SLabel = Instance.new("TextLabel", SFrame); SLabel.Text = "  " .. text .. ": " .. _G.SETTINGS[key]; SLabel.Size = UDim2.new(1, 0, 0.5, 0); SLabel.BackgroundTransparency = 1; SLabel.TextColor3 = Color3.new(1,1,1); SLabel.Font = Enum.Font.Gotham; SLabel.TextSize = 12; SLabel.TextXAlignment = Enum.TextXAlignment.Left
    local SliderBg = Instance.new("Frame", SFrame); SliderBg.Size = UDim2.new(0.9, 0, 0, 4); SliderBg.Position = UDim2.new(0.05, 0, 0.75, 0); SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", SliderBg)
    local SliderFill = Instance.new("Frame", SliderBg); SliderFill.Size = UDim2.new((_G.SETTINGS[key]-min)/(max-min), 0, 1, 0); SliderFill.BackgroundColor3 = _G.SETTINGS.AccentColor; Instance.new("UICorner", SliderFill)
    SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then local move; move = UIS.InputChanged:Connect(function(m) if m.UserInputType == Enum.UserInputType.MouseMovement or m.UserInputType == Enum.UserInputType.Touch then local rel = math.clamp((m.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1); local val = math.floor((min + (max - min) * rel) * 100) / 100; SliderFill.Size = UDim2.new(rel, 0, 1, 0); SLabel.Text = "  " .. text .. ": " .. val; _G.SETTINGS[key] = val end end) local endc; endc = UIS.InputEnded:Connect(function(e) if e.UserInputType == Enum.UserInputType.MouseButton1 or e.UserInputType == Enum.UserInputType.Touch then move:Disconnect(); endc:Disconnect() end end) end end)
end

-- SEKACJA COMBAT
AddToggle("Smart Sticky Aimbot", "AimbotEnabled")
AddSlider("Smoothness", 0.01, 1.0, "AimSmooth")
AddSlider("FOV Size", 50, 600, "FOV")

-- SEKCJA VISUALS
AddToggle("CS:GO Box ESP", "BoxVisible")
AddToggle("Skeleton ESP (Lite)", "SkeletonEnabled")
AddToggle("Tracers (od myszki)", "TracersEnabled")
AddToggle("Hand Neon Chams", "HandChamsEnabled") -- NOWE
AddToggle("ESP: Pasek Zycia", "HealthbarVisible")
AddToggle("ESP: Nazwy + HP", "NametagsVisible")

local MenuBtn = Instance.new("TextButton", Screen); MenuBtn.Size = UDim2.new(0, 80, 0, 30); MenuBtn.Position = UDim2.new(0.5, -40, 0, 10); MenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); MenuBtn.Text = "MENU"; MenuBtn.TextColor3 = _G.SETTINGS.AccentColor; MenuBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", MenuBtn); MenuBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UIS.InputBegan:Connect(function(i) if i.KeyCode == _G.SETTINGS.MenuKey then Main.Visible = not Main.Visible end end)

return true
