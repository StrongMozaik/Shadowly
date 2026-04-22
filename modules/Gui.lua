local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local ParentContainer = (gethui and gethui()) or game:GetService("CoreGui")

if ParentContainer:FindFirstChild("ShadowElite_UI") then ParentContainer:FindFirstChild("ShadowElite_UI"):Destroy() end

local Screen = Instance.new("ScreenGui", ParentContainer); Screen.Name = "ShadowElite_UI"; Screen.IgnoreGuiInset = true
local Main = Instance.new("Frame", Screen); Main.Size = UDim2.new(0, 420, 0, 500); Main.Position = UDim2.new(0.5, -210, 0.5, -250); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14); Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = _G.SETTINGS.AccentColor; MainStroke.Thickness = 2

local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header); Title.Text = "  SHADOW ELITE v12.5 | RIVALS"; Title.Size = UDim2.new(1, 0, 1, 0); Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

local Content = Instance.new("ScrollingFrame", Main); Content.Size = UDim2.new(1, -20, 1, -70); Content.Position = UDim2.new(0, 10, 0, 60); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 0; Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 10)

-- [[ OBSŁUGA DOTYKU I PRZESUWANIA (MOBILE) ]] --
local drag, dragS, startP
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = true; dragS = i.Position; startP = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragS
        Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset + delta.X, startP.Y.Scale, startP.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
end)

-- [[ ELEMENTY GUI ]] --
local function AddToggle(text, key)
    local T = Instance.new("TextButton", Content); T.Size = UDim2.new(1, 0, 0, 40); T.BackgroundColor3 = Color3.fromRGB(20, 20, 24); T.Text = "  " .. text; T.TextColor3 = Color3.fromRGB(200, 200, 200); T.Font = Enum.Font.GothamMedium; T.TextSize = 14; T.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", T)
    local Ind = Instance.new("Frame", T); Ind.Size = UDim2.new(0, 4, 0, 24); Ind.Position = UDim2.new(0, 0, 0.5, -12); Ind.BackgroundColor3 = _G.SETTINGS[key] and _G.SETTINGS.AccentColor or Color3.fromRGB(45, 45, 45)
    T.MouseButton1Click:Connect(function()
        _G.SETTINGS[key] = not _G.SETTINGS[key]
        TS:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = _G.SETTINGS[key] and _G.SETTINGS.AccentColor or Color3.fromRGB(45, 45, 45)}):Play()
    end)
end

local function AddSlider(text, min, max, key)
    local SFrame = Instance.new("Frame", Content); SFrame.Size = UDim2.new(1, 0, 0, 60); SFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24); Instance.new("UICorner", SFrame)
    local SLabel = Instance.new("TextLabel", SFrame); SLabel.Text = "  " .. text .. ": " .. _G.SETTINGS[key]; SLabel.Size = UDim2.new(1, 0, 0, 30); SLabel.BackgroundTransparency = 1; SLabel.TextColor3 = Color3.new(1,1,1); SLabel.Font = Enum.Font.Gotham; SLabel.TextSize = 13; SLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBg = Instance.new("Frame", SFrame); SliderBg.Size = UDim2.new(0.9, 0, 0, 6); SliderBg.Position = UDim2.new(0.05, 0, 0.7, 0); SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", SliderBg)
    local SliderFill = Instance.new("Frame", SliderBg); SliderFill.Size = UDim2.new((_G.SETTINGS[key]-min)/(max-min), 0, 1, 0); SliderFill.BackgroundColor3 = _G.SETTINGS.AccentColor; Instance.new("UICorner", SliderFill)

    local function Update(input)
        local rel = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * rel) * 100) / 100
        SliderFill.Size = UDim2.new(rel, 0, 1, 0)
        SLabel.Text = "  " .. text .. ": " .. val
        _G.SETTINGS[key] = val
    end

    SliderBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local move; move = UIS.InputChanged:Connect(function(m)
                if m.UserInputType == Enum.UserInputType.MouseMovement or m.UserInputType == Enum.UserInputType.Touch then Update(m) end
            end)
            local endc; endc = UIS.InputEnded:Connect(function(e)
                if e.UserInputType == Enum.UserInputType.MouseButton1 or e.UserInputType == Enum.UserInputType.Touch then move:Disconnect(); endc:Disconnect() end
            end)
            Update(i)
        end
    end)
end

-- [[ LISTA KONTROLEK ]] --
AddToggle("Włącz Aimbot", "AimbotEnabled")
-- Tutaj Twój nowy zakres 0.1 - 1.5 z opisem trybów
AddSlider("Smoothness (0.1 Silent - 1.5 Smooth)", 0.1, 1.5, "AimSmooth")
AddSlider("Zasięg FOV", 30, 600, "FOV")

AddToggle("Rozciągnięty Ekran (4:3)", "StretchedRes")
AddToggle("Pokaż Boxy (ESP)", "BoxVisible")
AddToggle("Linie do graczy (Tracers)", "TracersEnabled")
AddToggle("Nazwy Graczy i HP", "NametagsVisible")

-- [[ PRZYCISK MENU ]] --
local MenuBtn = Instance.new("TextButton", Screen); MenuBtn.Size = UDim2.new(0, 100, 0, 35); MenuBtn.Position = UDim2.new(0.5, -50, 0, 15); MenuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); MenuBtn.Text = "MENU"; MenuBtn.TextColor3 = _G.SETTINGS.AccentColor; MenuBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", MenuBtn); local BStroke = Instance.new("UIStroke", MenuBtn); BStroke.Color = _G.SETTINGS.AccentColor; BStroke.Thickness = 2
MenuBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

return true
