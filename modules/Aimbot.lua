-- [[ SHADOW HUB: AIMBOT MODULE (SMART STICKY + FOV) ]] --
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

local LockedTarget = nil

-- [[ FOV DRAWING ]] --
local FOV_C = Drawing.new("Circle")
FOV_C.Thickness = 1
FOV_C.Color = _G.SETTINGS.AccentColor
FOV_C.Visible = true
FOV_C.Filled = false
FOV_C.Transparency = 1

-- [[ TARGETING FUNCTION ]] --
local function GetClosestTarget()
    local mouse = UIS:GetMouseLocation()
    local closestDist = _G.SETTINGS.FOV
    local target = nil
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    target = p
                end
            end
        end
    end
    return target, closestDist
end

-- [[ MAIN AIM LOOP ]] --
RunService.RenderStepped:Connect(function()
    -- Aktualizacja FOV Circle
    FOV_C.Position = UIS:GetMouseLocation()
    FOV_C.Radius = _G.SETTINGS.FOV
    FOV_C.Visible = _G.SETTINGS.AimbotEnabled
    FOV_C.Color = _G.SETTINGS.AccentColor

    -- Sprawdzanie czy klawisz jest wciśnięty (Obsługa PC i Mobile)
    local IsPressed = _G.SETTINGS.AimIsMouse and UIS:IsMouseButtonPressed(_G.SETTINGS.AimKey) or UIS:IsKeyDown(_G.SETTINGS.AimKey)
    
    if _G.SETTINGS.AimbotEnabled and IsPressed then
        local mouse = UIS:GetMouseLocation()
        local bestTarget, bestDist = GetClosestTarget()
        
        -- Smart Sticky Logic
        if not LockedTarget or (LockedTarget.Character and LockedTarget.Character:FindFirstChild("Humanoid") and LockedTarget.Character.Humanoid.Health <= 0) then
            LockedTarget = bestTarget
        else
            -- Przełączanie celu, jeśli inny wróg jest znacznie bliżej środka FOV
            local hrp = LockedTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local currentPos = Camera:WorldToViewportPoint(hrp.Position)
                local currentDist = (Vector2.new(currentPos.X, currentPos.Y) - mouse).Magnitude
                if bestTarget and bestTarget ~= LockedTarget and bestDist < (currentDist * 0.7) then
                    LockedTarget = bestTarget
                end
            end
        end

        -- Ruch myszką do celu
        if LockedTarget and LockedTarget.Character then
            local hrp = LockedTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Uwzględnienie Head Height Offset
                local headPos = hrp.Position + Vector3.new(0, (LockedTarget.Character:GetExtentsSize().Y * (0.5 - _G.SETTINGS.HeadOffset)), 0)
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                
                if onScreen then
                    local dX = (screenPos.X - mouse.X) * _G.SETTINGS.AimSmooth
                    local dY = (screenPos.Y - mouse.Y) * _G.SETTINGS.AimSmooth
                    
                    -- Funkcja przesunięcia (wymaga sensownego injectora)
                    if mousemoverel then
                        mousemoverel(dX, dY)
                    end
                end
            end
        end
    else
        LockedTarget = nil
    end
end)

return true
