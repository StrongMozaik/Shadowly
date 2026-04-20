-- [[ SHADOW HUB: MOUSE-TO-TARGET TRACERS ]] --
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local TracerCache = {}

local function CreateTracer(p)
    local line = Drawing.new("Line")
    line.Thickness = 1
    line.Transparency = 1
    line.Visible = false
    line.Color = _G.SETTINGS.AccentColor
    TracerCache[p] = line
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LP then CreateTracer(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LP then CreateTracer(p) end end)
Players.PlayerRemoving:Connect(function(p) 
    if TracerCache[p] then TracerCache[p]:Remove(); TracerCache[p] = nil end 
end)

RunService.RenderStepped:Connect(function()
    local MousePos = UIS:GetMouseLocation()

    for p, line in pairs(TracerCache) do
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if _G.SETTINGS.TracersEnabled and hrp and hum and hum.Health > 0 then
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                line.From = MousePos -- Start linii w miejscu myszki (środek koła FOV)
                line.To = Vector2.new(screenPos.X, screenPos.Y) -- Koniec na przeciwniku
                line.Color = _G.SETTINGS.AccentColor
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end)

return true
