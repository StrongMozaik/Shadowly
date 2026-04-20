-- [[ SHADOW HUB: AIMBOT MODULE (FIXED FOV RADIUS) ]] --
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

local LockedTarget = nil
local FOV_C = Drawing.new("Circle")
FOV_C.Thickness = 1
FOV_C.Transparency = 1
FOV_C.Filled = false

-- [[ POPRAWIONA FUNKCJA CELOWANIA ]] --
local function GetClosestTarget()
    local mouse = UIS:GetMouseLocation()
    local maxDist = _G.SETTINGS.FOV -- To jest limit
    local closestDist = maxDist
    local target = nil
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                -- KLUCZOWA ZMIANA: Sprawdzamy czy dist jest mniejszy niż ustawiony FOV
                if dist <= maxDist and dist < closestDist then
                    closestDist = dist
                    target = p
                end
            end
        end
    end
    return target, closestDist
end

RunService.RenderStepped:Connect(function()
    -- Aktualizacja wizualna koła
    FOV_C.Position = UIS:GetMouseLocation()
    FOV_C.Radius = _G.SETTINGS.FOV
    FOV_C.Color = _G.SETTINGS.AccentColor
    FOV_C.Visible = _G.SETTINGS.AimbotEnabled

    local IsPressed = _G.SETTINGS.AimIsMouse and UIS:IsMouseButtonPressed(_G.SETTINGS.AimKey) or UIS:IsKeyDown(_G.SETTINGS.AimKey)
    
    if _G.SETTINGS.AimbotEnabled and IsPressed then
        local mouse = UIS:GetMouseLocation()
        local bestTarget, bestDist = GetClosestTarget()
        
        -- Jeśli mamy już cel, sprawdzamy czy nadal jest w FOV
        if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LockedTarget.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
            
            -- Jeśli cel ucieknie poza FOV lub zginie, puszczamy go
            if not onScreen or dist > _G.SETTINGS.FOV or LockedTarget.Character.Humanoid.Health <= 0 then
                LockedTarget = nil
            end
        end

        -- Jeśli nie mamy celu, przypisujemy najlepszy znaleziony w FOV
        if not LockedTarget then
            LockedTarget = bestTarget
        end

        -- Ruch do celu
        if LockedTarget and LockedTarget.Character then
            local hrp = LockedTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local headPos = hrp.Position + Vector3.new(0, (LockedTarget.Character:GetExtentsSize().Y * (0.5 - _G.SETTINGS.HeadOffset)), 0)
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                if onScreen then
                    if mousemoverel then
                        mousemoverel((screenPos.X - mouse.X) * _G.SETTINGS.AimSmooth, (screenPos.Y - mouse.Y) * _G.SETTINGS.AimSmooth)
                    end
                end
            end
        end
    else
        LockedTarget = nil
    end
end)

return true
