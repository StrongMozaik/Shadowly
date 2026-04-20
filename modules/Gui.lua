local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = game:GetService("Players").LocalPlayer
local ParentContainer = (gethui and gethui()) or game:GetService("CoreGui")

if ParentContainer:FindFirstChild("ShadowElite_UI") then
    ParentContainer:FindFirstChild("ShadowElite_UI"):Destroy()
end

local Screen = Instance.new("ScreenGui", ParentContainer)
Screen.Name = "ShadowElite_UI"
Screen.IgnoreGuiInset = true

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 400, 0, 450)
Main.Position = UDim2.new(0.5, -200, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = _G.SETTINGS.AccentColor
MainStroke.Thickness = 1.5

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Text = "  RIVALS | SHADOW ELITE v11.7 PRESET"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 0
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

-- [[ MOBILNE PRZECIĄGANIE ]] --
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- [[ KOMPONENTY ]] --
local function AddToggle(text, settingKey, callback)
    local T = Instance.new("TextButton", Content)
    T.Size = UDim2.new(1, 0, 0, 38)
    T.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    T.Text = "  " .. text
    T.TextColor3 = Color3.fromRGB(180, 180, 180)
    T.Font = Enum.Font.Gotham
    T.TextSize = 13
    T.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", T)

    local Ind = Instance.new("Frame", T)
    Ind.Size = UDim2.new(0, 4, 0, 20)
    Ind.Position = UDim2.new(0, 0, 0.5, -10)
    Ind.BackgroundColor3 = _G.SETTINGS[settingKey] and _G.SETTINGS.AccentColor or Color3.fromRGB(40, 40, 40)

    T.MouseButton1Click:Connect(function()
        _G.SETTINGS[settingKey] = not _G.SETTINGS[settingKey]
        TS:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = _G.SETTINGS[settingKey] and _G.SETTINGS.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
        if callback then callback(_G.SETTINGS[settingKey]) end
    end)
end

local function AddSlider(text, min, max, settingKey, callback)
    local SFrame = Instance.new("Frame", Content)
    SFrame.Size = UDim2.new(1, 0, 0, 50)
    SFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Instance.new("UICorner", SFrame)

    local SLabel = Instance.new("TextLabel", SFrame)
    SLabel.Text = "  " .. text .. ": " .. _G.SETTINGS[settingKey]
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
    SliderFill.Size = UDim2.new((_G.SETTINGS[settingKey]-min)/(max-min), 0, 1, 0)
    SliderFill.BackgroundColor3 = _G.SETTINGS.AccentColor
    Instance.new("UICorner", SliderFill)

    local function MoveSlider(input)
        local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local val = min + (max - min) * pos
        val = math.floor(val * 100) / 100
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SLabel.Text = "  " .. text .. ": " .. val
        _G.SETTINGS[settingKey] = val
        if callback then callback(val) end
    end

    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local moveConn
            local endConn
            moveConn = UIS.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch then
                    MoveSlider(move)
                end
            end)
            endConn = UIS.InputEnded:Connect(function(ended)
                if ended.UserInputType == Enum.UserInputType.MouseButton1 or ended.UserInputType == Enum.UserInputType.Touch then
                    moveConn:Disconnect()
                    endConn:Disconnect()
                end
            end)
            MoveSlider(input)
        end
    end)
end

-- [[ GENEROWANIE MENU ]] --
AddToggle("Smart Sticky Aimbot", "AimbotEnabled")
AddSlider("Smoothness", 0.01, 1.0, "AimSmooth")
AddSlider("FOV Size", 50, 600, "FOV")
AddSlider("Head Height Offset", 0, 0.5, "HeadOffset")
AddToggle("CS:GO Box ESP", "BoxVisible")
AddToggle("ESP: Pasek Zycia", "HealthbarVisible")
AddToggle("ESP: Nazwy + HP", "NametagsVisible")
AddToggle("ESP: Odleglosc", "DistanceVisible")

-- Przycisk ukrywania (dla Mobile: dodajemy mały przycisk na ekranie)
local CloseBtn = Instance.new("TextButton", Screen)
CloseBtn.Size = UDim2.new(0, 50, 0, 20)
CloseBtn.Position = UDim2.new(0.5, -25, 0, 10)
CloseBtn.Text = "Menu"
CloseBtn.BackgroundColor3 = _G.SETTINGS.AccentColor
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end end)
