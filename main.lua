-- [[ SHADOW HUB: RIVALS ELITE v11.7 - PRESET CONFIG ]] --
-- [[ SYSTEM: SMART UNLOCK | AUTO-SWITCH | PRESET: v11.6 SCREEN ]] --

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- [[ PERSISTENCE SETUP ]] --
local ParentContainer = (gethui and gethui()) or CoreGui
if ParentContainer:FindFirstChild("ShadowElite_v117_Preset") then
    ParentContainer:FindFirstChild("ShadowElite_v117_Preset"):Destroy()
end

-- [[ GLOBAL SETTINGS - ZAKTUALIZOWANE NA STANDARDOWE Z FOTO ]] --
_G.SETTINGS = {
    AimbotEnabled = true,        -- Włączone na start
    AimSmooth = 0.73,            -- Ustawione na 0.73
    FOV = 150,                   -- Ustawione na 150
    AimKey = Enum.UserInputType.MouseButton1, -- MB1 jak na foto
    AimIsMouse = true,
    HeadOffset = 0.28,           -- Ustawione na 0.28
    BoxVisible = true,           -- Włączone na start
    NametagsVisible = true,      -- Włączone na start
    HealthbarVisible = true,     -- Włączone na start
    DistanceVisible = false,     -- Wyłączone na start
    AccentColor = Color3.fromRGB(255, 60, 60)
}

local LockedTarget = nil
local RandomGen = Random.new()
local Binding = false

-- [[ UI CONSTRUCTION ]] --
local Screen = Instance.new("ScreenGui")
Screen.Name = "ShadowElite_v117_Preset"
Screen.Parent = ParentContainer
Screen.IgnoreGuiInset = true

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 400, 0, 450); Main.Position = UDim2.new(0.5, -200, 0.5, -225); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14); Main.BorderSizePixel = 0; Main.ZIndex = 10000; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = _G.SETTINGS.AccentColor; MainStroke.Thickness = 1.5

local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundTransparency = 1; Header.ZIndex = 10001
local Title = Instance.new("TextLabel", Header); Title.Text = "  RIVALS | SHADOW ELITE v11.7 PRESET"; Title.Size = UDim2.new(1, 0, 1, 0); Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1; Title.ZIndex = 10002

local Content = Instance.new("ScrollingFrame", Main); Content.Size = UDim2.new(1, -20, 1, -60); Content.Position = UDim2.new(0, 10, 0, 55); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 0; Content.AutomaticCanvasSize = Enum.AutomaticSize.Y; Content.ZIndex = 10001
Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

-- [[ UI COMPONENTS ]] --
local function AddToggle(text, isAim, defaultState, callback)
    local T = Instance.new("TextButton", Content)
    T.Size = UDim2.new(1, 0, 0, 38); T.BackgroundColor3 = Color3.fromRGB(20, 20, 24); T.Text = "  " .. text; T.TextColor3 = Color3.fromRGB(180, 180, 180); T.Font = Enum.Font.Gotham; T.TextSize = 13; T.TextXAlignment = Enum.TextXAlignment.Left; T.AutoButtonColor = false; T.ZIndex = 10002; Instance.new("UICorner", T)
    local Ind = Instance.new("Frame", T); Ind.Size = UDim2.new(0, 4, 0, 20); Ind.Position = UDim2.new(0, 0, 0.5, -10); Ind.BackgroundColor3 = defaultState and _G.SETTINGS.AccentColor or Color3.fromRGB(40, 40, 40); Ind.ZIndex = 10003
    local act = defaultState
    T.MouseButton1Click:Connect(function()
        if Binding then return end
        act = not act
        TS:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = act and _G.SETTINGS.AccentColor or Color3.fromRGB(40, 40, 40)}):Play()
        callback(act)
    end)
    if isAim then
        T.MouseButton2Click:Connect(function()
            Binding = true; T.Text = "  PRESS ANY KEY..."
            local conn; conn = UIS.InputBegan:Connect(function(i)
                local key = (i.KeyCode ~= Enum.KeyCode.Unknown and i.KeyCode) or (i.UserInputType.Name:find("MouseButton") and i.UserInputType)
                if key then 
                    _G.SETTINGS.AimKey = key; 
                    _G.SETTINGS.AimIsMouse = tostring(key):find("MouseButton"); 
                    T.Text = "  " .. text .. " [" .. tostring(key.Name):gsub("MouseButton", "MB") .. "]"; 
                    Binding = false; conn:Disconnect() 
                end
            end)
        end)
        T.Text = "  " .. text .. " [" .. tostring(_G.SETTINGS.AimKey.Name):gsub("MouseButton", "MB") .. "]"
    end
end

local function AddSlider(text, min, max, default, callback)
    local SFrame = Instance.new("Frame", Content); SFrame.Size = UDim2.new(1, 0, 0, 50); SFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24); SFrame.ZIndex = 10002; Instance.new("UICorner", SFrame)
    local SLabel = Instance.new("TextLabel", SFrame); SLabel.Text = "  " .. text .. ": " .. default; SLabel.Size = UDim2.new(1, 0, 0.5, 0); SLabel.BackgroundTransparency = 1; SLabel.TextColor3 = Color3.new(1,1,1); SLabel.Font = Enum.Font.Gotham; SLabel.TextSize = 12; SLabel.TextXAlignment = Enum.TextXAlignment.Left; SLabel.ZIndex = 10003
    local SliderBg = Instance.new("Frame", SFrame); SliderBg.Size = UDim2.new(0.9, 0, 0, 4); SliderBg.Position = UDim2.new(0.05, 0, 0.75, 0); SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40); SliderBg.ZIndex = 10003; Instance.new("UICorner", SliderBg)
    local SliderFill = Instance.new("Frame", SliderBg); SliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); SliderFill.BackgroundColor3 = _G.SETTINGS.AccentColor; SliderFill.ZIndex = 10004; Instance.new("UICorner", SliderFill)
    local s_drag = false
    local function Upd()
        local rel = math.clamp((UIS:GetMouseLocation().X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(rel, 0, 1, 0); local val = min + (max - min) * rel; SLabel.Text = string.format("  %s: %.2f", text, val); callback(val)
    end
    SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then s_drag = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then s_drag = false end end)
    UIS.InputChanged:Connect(function(i) if s_drag and i.UserInputType == Enum.UserInputType.MouseMovement then Upd() end end)
end

-- [[ DRAWING CACHE & ESP LOGIC ]] --
local Cache = {}
local FOV_C = Drawing.new("Circle")
FOV_C.Thickness = 1; FOV_C.Color = _G.SETTINGS.AccentColor; FOV_C.Visible = _G.SETTINGS.AimbotEnabled

local function CreateDrawings(p)
    Cache[p] = {
        MainBox = Drawing.new("Square"), InOutline = Drawing.new("Square"), OutOutline = Drawing.new("Square"),
        Healthbar = Drawing.new("Square"), HealthFill = Drawing.new("Square"),
        Nametag = Drawing.new("Text"), Distance = Drawing.new("Text")
    }
    local obj = Cache[p]
    obj.Nametag.Size = 16; obj.Nametag.Color = Color3.new(1,1,1); obj.Nametag.Outline = true; obj.Nametag.Center = true
    obj.Distance.Size = 14; obj.Distance.Color = Color3.new(1,1,1); obj.Distance.Outline = true; obj.Distance.Center = true
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LP then CreateDrawings(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LP then CreateDrawings(p) end end)

local function GetClosestTarget()
    local mouse = UIS:GetMouseLocation()
    local closestDist = _G.SETTINGS.FOV
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                if dist < closestDist then closestDist = dist; target = p end
            end
        end
    end
    return target, closestDist
end

-- [[ MAIN LOOP ]] --
RunService.RenderStepped:Connect(function()
    FOV_C.Position = UIS:GetMouseLocation(); FOV_C.Radius = _G.SETTINGS.FOV
    
    for p, obj in pairs(Cache) do
        local char = p.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local topPos, topOnScreen = Camera:WorldToViewportPoint((char:GetPivot() * CFrame.new(0, char:GetExtentsSize().Y / 2 + 0.2, 0)).Position)
            local bottomPos, bottomOnScreen = Camera:WorldToViewportPoint((char:GetPivot() * CFrame.new(0, -char:GetExtentsSize().Y / 2 - 0.2, 0)).Position)
            local hrpPos, hrpOnScreen = Camera:WorldToViewportPoint(hrp.Position)

            if hrpOnScreen and topOnScreen and bottomOnScreen then
                local sY = math.abs(topPos.Y - bottomPos.Y); local sX = sY * 0.6; local bX, bY = hrpPos.X - sX / 2, topPos.Y
                
                obj.MainBox.Visible = _G.SETTINGS.BoxVisible; if _G.SETTINGS.BoxVisible then
                    obj.MainBox.Size = Vector2.new(sX, sY); obj.MainBox.Position = Vector2.new(bX, bY); obj.MainBox.Color = Color3.new(1,1,1)
                    obj.InOutline.Visible = true; obj.InOutline.Size = Vector2.new(sX-2, sY-2); obj.InOutline.Position = Vector2.new(bX+1, bY+1)
                    obj.OutOutline.Visible = true; obj.OutOutline.Size = Vector2.new(sX+2, sY+2); obj.OutOutline.Position = Vector2.new(bX-1, bY-1)
                else obj.InOutline.Visible = false; obj.OutOutline.Visible = false end
                
                obj.Healthbar.Visible = _G.SETTINGS.HealthbarVisible; obj.HealthFill.Visible = _G.SETTINGS.HealthbarVisible
                if _G.SETTINGS.HealthbarVisible then
                    local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    obj.Healthbar.Size = Vector2.new(4, sY); obj.Healthbar.Position = Vector2.new(bX - 6, bY)
                    obj.HealthFill.Size = Vector2.new(2, (sY - 2) * hpPct); obj.HealthFill.Position = Vector2.new(bX - 5, bY + 1 + (sY - 2) * (1 - hpPct))
                    obj.HealthFill.Color = Color3.fromHSV(hpPct * 0.3, 1, 1)
                end
                
                obj.Nametag.Visible = _G.SETTINGS.NametagsVisible; if _G.SETTINGS.NametagsVisible then
                    obj.Nametag.Position = Vector2.new(hrpPos.X, bY - 18); obj.Nametag.Text = p.Name .. " | " .. math.floor(hum.Health) .. "HP"
                end
                
                obj.Distance.Visible = _G.SETTINGS.DistanceVisible; if _G.SETTINGS.DistanceVisible then
                    obj.Distance.Position = Vector2.new(hrpPos.X, bY + sY + 2); obj.Distance.Text = "[" .. math.floor(hrpPos.Z * 0.3) .. "m]"
                end
            else for _,v in pairs(obj) do v.Visible = false end end
        else for _,v in pairs(obj) do v.Visible = false end end
    end

    local IsPressed = _G.SETTINGS.AimIsMouse and UIS:IsMouseButtonPressed(_G.SETTINGS.AimKey) or UIS:IsKeyDown(_G.SETTINGS.AimKey)
    if _G.SETTINGS.AimbotEnabled and IsPressed then
        local mouse = UIS:GetMouseLocation()
        local bestTarget, bestDist = GetClosestTarget()
        if not LockedTarget or (LockedTarget.Character and LockedTarget.Character:FindFirstChild("Humanoid") and LockedTarget.Character.Humanoid.Health <= 0) then
            LockedTarget = bestTarget
        else
            local currentPos = Camera:WorldToViewportPoint(LockedTarget.Character.HumanoidRootPart.Position)
            local currentDist = (Vector2.new(currentPos.X, currentPos.Y) - mouse).Magnitude
            if bestTarget and bestTarget ~= LockedTarget and bestDist < (currentDist * 0.7) then
                LockedTarget = bestTarget
            end
        end

        if LockedTarget and LockedTarget.Character then
            local hrp = LockedTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local headPos = hrp.Position + Vector3.new(0, (LockedTarget.Character:GetExtentsSize().Y * (0.5 - _G.SETTINGS.HeadOffset)), 0)
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                if onScreen then
                    local dX = (screenPos.X - mouse.X) * _G.SETTINGS.AimSmooth
                    local dY = (screenPos.Y - mouse.Y) * _G.SETTINGS.AimSmooth
                    if mousemoverel then mousemoverel(dX, dY) end
                end
            end
        end
    else
        LockedTarget = nil
    end
end)

-- [[ UI SETUP Z WARTOŚCIAMI Z FOTO ]] --
AddToggle("Smart Sticky Aimbot", true, _G.SETTINGS.AimbotEnabled, function(v) _G.SETTINGS.AimbotEnabled = v; FOV_C.Visible = v end)
AddSlider("Smoothness", 0.01, 1.0, _G.SETTINGS.AimSmooth, function(v) _G.SETTINGS.AimSmooth = v end)
AddSlider("FOV Size", 50, 600, _G.SETTINGS.FOV, function(v) _G.SETTINGS.FOV = v end)
AddSlider("Head Height Offset", 0, 0.5, _G.SETTINGS.HeadOffset, function(v) _G.SETTINGS.HeadOffset = v end)
AddToggle("CS:GO Box ESP", false, _G.SETTINGS.BoxVisible, function(v) _G.SETTINGS.BoxVisible = v end)
AddToggle("ESP: Pasek Zycia", false, _G.SETTINGS.HealthbarVisible, function(v) _G.SETTINGS.HealthbarVisible = v end)
AddToggle("ESP: Nazwy + HP", false, _G.SETTINGS.NametagsVisible, function(v) _G.SETTINGS.NametagsVisible = v end)
AddToggle("ESP: Odleglosc", false, _G.SETTINGS.DistanceVisible, function(v) _G.SETTINGS.DistanceVisible = v end)

-- DRAG & TOGGLE
local d_act, d_st, s_p = false, nil, nil
Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d_act = true; d_st = i.Position; s_p = Main.Position end end)
UIS.InputChanged:Connect(function(i) if d_act and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - d_st; Main.Position = UDim2.new(s_p.X.Scale, s_p.X.Offset + delta.X, s_p.Y.Scale, s_p.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function() d_act = false end)
UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.Insert then Main.Visible = not Main.Visible end end)
