local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local SkeletonCache = {}

local Connections = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
}

local function CreateSkeleton(p)
    local lines = {}
    for i = 1, #Connections do
        local l = Drawing.new("Line"); l.Thickness = 1; l.Transparency = 1; l.Visible = false
        lines[i] = l
    end
    SkeletonCache[p] = lines
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LP then CreateSkeleton(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LP then CreateSkeleton(p) end end)

RunService.RenderStepped:Connect(function()
    for p, lines in pairs(SkeletonCache) do
        local char = p.Character
        if _G.SETTINGS.SkeletonEnabled and char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            for i, conn in pairs(Connections) do
                local p1, p2 = char:FindFirstChild(conn[1]), char:FindFirstChild(conn[2])
                if p1 and p2 then
                    local pos1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                    local pos2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                    if vis1 and vis2 then
                        lines[i].From = Vector2.new(pos1.X, pos1.Y); lines[i].To = Vector2.new(pos2.X, pos2.Y)
                        lines[i].Visible = true; lines[i].Color = _G.SETTINGS.AccentColor
                    else lines[i].Visible = false end
                else lines[i].Visible = false end
            end
        else for _, l in pairs(lines) do l.Visible = false end end
    end
end)
