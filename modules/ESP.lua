local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Cache = {}

local function CreateDrawings(p)
    Cache[p] = {
        MainBox = Drawing.new("Square"),
        InOutline = Drawing.new("Square"),
        OutOutline = Drawing.new("Square"),
        Healthbar = Drawing.new("Square"),
        HealthFill = Drawing.new("Square"),
        Nametag = Drawing.new("Text"),
        Distance = Drawing.new("Text")
    }
    local obj = Cache[p]
    obj.Nametag.Size = 16; obj.Nametag.Outline = true; obj.Nametag.Center = true; obj.Nametag.Color = Color3.new(1,1,1)
    obj.Distance.Size = 14; obj.Distance.Outline = true; obj.Distance.Center = true; obj.Distance.Color = Color3.new(1,1,1)
end

for _, p in pairs(Players:GetPlayers()) do if p ~= game:GetService("Players").LocalPlayer then CreateDrawings(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= game:GetService("Players").LocalPlayer then CreateDrawings(p) end end)

RunService.RenderStepped:Connect(function()
    for p, obj in pairs(Cache) do
        local char = p.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            -- [ Tutaj wklejasz logikę rysowania Boxów i HP barów, którą mieliśmy w v11.7 ] --
            -- Pamiętaj o używaniu _G.SETTINGS.BoxVisible itd.
        else
            for _, v in pairs(obj) do v.Visible = false end
        end
    end
end)
