-- [[ SHADOW HUB: OFFICIAL GUI MODULE (MOBILE & PC) ]] --
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local ParentContainer = (gethui and gethui()) or game:GetService("CoreGui")

-- Usuwanie starego GUI przed załadowaniem nowego
if ParentContainer:FindFirstChild("ShadowElite_UI") then 
    ParentContainer:FindFirstChild("ShadowElite_UI"):Destroy() 
end

local Screen = Instance.new("ScreenGui", ParentContainer)
Screen.Name = "ShadowElite_UI"
Screen.IgnoreGuiInset = true

-- Główne Okno
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 400, 0, 450)
Main.Position = UDim2.new(0.5, -200, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = _G.SETTINGS.AccentColor
MainStroke.Thickness = 1.5

-- Nagłówek (Header)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Text = "  RIVALS | SHADOW ELITE v11.7"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Kontener na opcje (Scrolling)
local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 0
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0, 8)

-- [[ FUNKCJA PRZECIĄGANIA (PC & MOBILE) ]] --
local drag, dragS, startP
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dragS = i.Position
        startP = Main.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragS
        Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset + delta.X, startP.Y.Scale, startP.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = false
    end
end)

-- [[ KOMPONENTY GUI ]] --

-- Toggle (Włącznik)
local function AddToggle(text, key)
    local T = Instance.new("TextButton", Content)
    T.Size = UDim2.new(1, 0, 0, 38)
    T.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    T.Text = "  " .. text
    T.TextColor3 = Color3.fromRGB(180, 180, 180)
    T.Font = Enum.Font.Gotham
    T.TextSize = 13
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.AutoButtonColor = false
    Instance.new("UICorner", T)

    local Ind = Instance.new("Frame", T)
    Ind.Size = UDim2.new(0, 4, 0, 20)
    Ind.Position = UDim2.new(0, 0, 0.5, -10)
    Ind.BackgroundColor3 = _G.SETTINGS[key] and _G.SETTINGS.AccentColor or Color3.fromRGB(40, 40, 40)

    T.MouseButton1Click:Connect(function()
        _G.SETTINGS[key] = not _G.SETTINGS[key]
        TS:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = _G.SETTINGS[key] and _G.SETTINGS.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
    end)
end

-- Slider (Suwak)
local function AddSlider(text, min, max, key)
    local SFrame = Instance.new("Frame", Content)
    SFrame.Size = UDim2.new(1, 0, 0, 50)
    SFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Instance.new("UICorner", SFrame)

    local SLabel = Instance.new("TextLabel", SFrame)
    SLabel.Text = "  " .. text .. ": " .. _G.SETTINGS[key]
    SLabel.Size = UDim2.new(1, 0, 0.5, 0)
    SLabel.BackgroundTransparency = 1
    SLabel.TextColor3 = Color3.new(1,1,1)
    SLabel.Font = Enum.Font.Gotham
    SLabel.TextSize = 12
    SLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBg = Instance.new("Frame", SFrame)
    SliderBg.Size = UDim2.new(0.9, 0, 0, 4)
    SliderBg.Position = UDim2.new(0.05, 0, 0.75, 0)
    SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", SliderBg)

    local SliderFill = Instance.new("Frame", SliderBg)
    SliderFill.Size = UDim2.new((_G.SETTINGS[key]-min)/(max-min), 0, 1, 0)
    SliderFill.BackgroundColor3 = _G.SETTINGS.AccentColor
    Instance.new("UICorner", SliderFill)

    local function UpdateSlider(input)
        local rel = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor((min + (max - min) * rel) * 100) / 100
        SliderFill.Size = UDim2.new(rel, 0, 1, 0)
        SLabel.Text = "  " .. text .. ": " .. val
        _G.SETTINGS[key] = val
    end

    SliderBg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local move; move = UIS.InputChanged:Connect(function(m)
                if m.UserInputType == Enum.UserInputType.MouseMovement or m.UserInputType == Enum.UserInputType.Touch then
                    UpdateSlider(m)
                end
            end)
            local endc; endc = UIS.InputEnded:Connect(function(e)
                if e.UserInputType == Enum.UserInputType.MouseButton1 or e.UserInputType == Enum.UserInputType.Touch then
                    move:Disconnect()
                    endc:Disconnect()
                end
            end)
            UpdateSlider(i)
        end
    end)
end

-- [[ GENEROWANIE PRZYCISKÓW ]] --

-- Aimbot Section
AddToggle("Smart Sticky Aimbot", "AimbotEnabled")
AddSlider("Smoothness", 0.01, 1.0, "AimSmooth")
AddSlider("FOV Size", 50, 600, "FOV")
AddSlider("Head Height Offset", 0, 0.5, "HeadOffset")

-- Visuals Section
AddToggle("CS:GO Box ESP", "BoxVisible")
AddToggle("Skeleton ESP (Lite)", "SkeletonEnabled")
AddToggle("Tracers (od celownika)", "TracersEnabled")
AddToggle("ESP: Pasek Zycia", "HealthbarVisible")
AddToggle("ESP: Nazwy + HP", "NametagsVisible")
AddToggle("ESP: Odleglosc", "DistanceVisible")

-- [[ PRZYCISKI OTWIERANIA ]] --

-- Przycisk dla Mobile (zawsze na ekranie)
local MenuBtn = Instance.new("TextButton", Screen)
MenuBtn.Size = UDim2.new(0, 80, 0, 30)
MenuBtn.Position = UDim2.new(0.5, -40, 0, 10)
MenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MenuBtn.Text = "MENU"
MenuBtn.TextColor3 = _G.SETTINGS.AccentColor
MenuBtn.Font = Enum.Font.GothamBold
MenuBtn.TextSize = 14
Instance.new("UICorner", MenuBtn)
Instance.new("UIStroke", MenuBtn).Color = _G.SETTINGS.AccentColor

MenuBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Klawisz Insert dla PC
UIS.InputBegan:Connect(function(i)
    if i.KeyCode == _G.SETTINGS.MenuKey then
        Main.Visible = not Main.Visible
    end
end)

return true
