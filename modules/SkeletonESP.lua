-- [[ SHADOW HUB: SKELETON ESP MODULE ]] --
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local SkeletonCache = {}

-- Definicja połączeń między stawami (pary części ciała)
local Connections = {
    -- Tułów i Głowa
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    -- Ramiona
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    -- Nogi
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"}
}

local function CreateSkeleton(p)
    local lines = {}
    for i = 1, #Connections do
        local l = Drawing.new("Line")
        l.Thickness = 1
        l.Transparency = 1
        l.Visible = false
        l.Color = _G.SETTINGS.AccentColor
        lines[i] = l
    end
    SkeletonCache[p] = lines
end

-- Obsługa dołączania i wychodzenia graczy
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LP then CreateSkeleton(p) end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LP then CreateSkeleton(p) end
end)

Players.PlayerRemoving:Connect(function(p)
    if SkeletonCache[p] then
        for _, line in pairs(SkeletonCache[p]) do
            line:Remove()
        end
        SkeletonCache[p] = nil
    end
end)

-- Główna pętla renderująca
RunService.RenderStepped:Connect(function()
    for p, lines in pairs(SkeletonCache) do
        local char = p.Character
        
        -- Sprawdzanie czy funkcja jest włączona i czy gracz żyje
        if _G.SETTINGS.SkeletonEnabled and char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            for i, conn in pairs(Connections) do
                local part1 = char:FindFirstChild(conn[1])
                local part2 = char:FindFirstChild(conn[2])
                local line = lines[i]

                if part1 and part2 then
                    local pos1, vis1 = Camera:WorldToViewportPoint(part1.Position)
                    local pos2, vis2 = Camera:WorldToViewportPoint(part2.Position)

                    if vis1 and vis2 then
                        line.From = Vector2.new(pos1.X, pos1.Y)
                        line.To = Vector2.new(pos2.X, pos2.Y)
                        line.Color = _G.SETTINGS.AccentColor
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        else
            -- Ukryj linie, jeśli gracz nie żyje lub funkcja jest wyłączona
            for _, line in pairs(lines) do
                line.Visible = false
            end
        end
    end
end)

return true
