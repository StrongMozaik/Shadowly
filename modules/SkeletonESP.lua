-- [[ SHADOW HUB: SKELETON ESP LITE ]] --
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local SkeletonCache = {}
local SkipFrame = 0

-- Uproszczone połączenia (Tylko najważniejsze stawy)
local Connections = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"UpperTorso", "RightUpperArm"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LowerTorso", "RightUpperLeg"}
}

local function CreateSkeleton(p)
    local lines = {}
    for i = 1, #Connections do
        local l = Drawing.new("Line")
        l.Thickness = 1
        l.Transparency = 0.8 -- Lekko przezroczyste, by mniej biło po oczach
        l.Visible = false
        lines[i] = l
    end
    SkeletonCache[p] = lines
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LP then CreateSkeleton(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LP then CreateSkeleton(p) end end)
Players.PlayerRemoving:Connect(function(p) SkeletonCache[p] = nil end)

RunService.RenderStepped:Connect(function()
    if not _G.SETTINGS.SkeletonEnabled then
        for _, lines in pairs(SkeletonCache) do
            for _, l in pairs(lines) do l.Visible = false end
        end
        return
    end

    -- Optymalizacja: Przetwarzaj tylko co drugą klatkę
    SkipFrame = SkipFrame + 1
    if SkipFrame % 2 ~= 0 then return end 

    for p, lines in pairs(SkeletonCache) do
        local char = p.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            for i, conn in pairs(Connections) do
                local p1, p2 = char:FindFirstChild(conn[1]), char:FindFirstChild(conn[2])
                if p1 and p2 then
                    local pos1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                    local pos2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                    
                    if vis1 and vis2 then
                        lines[i].From = Vector2.new(pos1.X, pos1.Y)
                        lines[i].To = Vector2.new(pos2.X, pos2.Y)
                        lines[i].Color = _G.SETTINGS.AccentColor
                        lines[i].Visible = true
                    else lines[i].Visible = false end
                else lines[i].Visible = false end
            end
        else
            for _, l in pairs(lines) do l.Visible = false end
        end
    end
end)

return true
