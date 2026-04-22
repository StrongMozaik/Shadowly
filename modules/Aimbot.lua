-- [[ SHADOW HUB: AIMBOT v2 (SILENT / STRICT / SMOOTH) ]] --
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

local function GetClosestTarget()
    local mouse = UIS:GetMouseLocation()
    local maxDist = _G.SETTINGS.FOV
    local closestDist = maxDist
    local target = nil
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local head = p.Character:FindFirstChild("Head")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            
            if head and hrp then
                local posHead, headVisible = Camera:WorldToViewportPoint(head.Position)
                local posHRP, hrpVisible = Camera:WorldToViewportPoint(hrp.Position)
                
                if headVisible or hrpVisible then
                    local distHead = (Vector2.new(posHead.X, posHead.Y) - mouse).Magnitude
                    local distHRP = (Vector2.new(posHRP.X, posHRP.Y) - mouse).Magnitude
                    local finalDist = math.min(distHead, distHRP)
                    
                    if finalDist <= maxDist and finalDist < closestDist then
                        closestDist = finalDist
                        target = p
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOV_C.Position = UIS:GetMouseLocation()
    FOV_C.Radius = _G.SETTINGS.FOV
    FOV_C.Color = _G.SETTINGS.AccentColor
    FOV_C.Visible = _G.SETTINGS.AimbotEnabled

    local IsPressed = _G.SETTINGS.AimIsMouse and UIS:IsMouseButtonPressed(_G.SETTINGS.AimKey) or UIS:IsKeyDown(_G.SETTINGS.AimKey)
    
    if _G.SETTINGS.AimbotEnabled and IsPressed then
        local mouse = UIS:GetMouseLocation()
        
        if not LockedTarget then
            LockedTarget = GetClosestTarget()
        end

        if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("HumanoidRootPart") then
            local hum = LockedTarget.Character:FindFirstChild("Humanoid")
            local hrp = LockedTarget.Character.HumanoidRootPart
            
            if hum and hum.Health > 0 then
                local headPos = hrp.Position + Vector3.new(0, (LockedTarget.Character:GetExtentsSize().Y * (0.5 - _G.SETTINGS.HeadOffset)), 0)
                local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
                
                -- Ulepszony margines trzymania celu (Sticky)
                if onScreen and dist <= (_G.SETTINGS.FOV * 1.3) then
                    if mousemoverel then
                        -- NOWA LOGIKA RUCHU:
                        -- Odwracamy działanie suwaka, aby wyższe wartości były wolniejsze
                        -- i zapobiegamy zeru (minimalna siła to 0.01)
                        local sensitivity = math.max(0.01, (2 - _G.SETTINGS.AimSmooth) / 5)
                        
                        -- Jeśli suwak jest bardzo nisko (Silent Mode), dajemy pełną moc
                        if _G.SETTINGS.AimSmooth <= 0.4 then
                            sensitivity = 1 
                        end

                        mousemoverel((screenPos.X - mouse.X) * sensitivity, (screenPos.Y - mouse.Y) * sensitivity)
                    end
                else
                    LockedTarget = nil
                end
            else
                LockedTarget = nil
            end
        end
    else
        LockedTarget = nil
    end
end)

return true
