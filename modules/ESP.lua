local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Cache = {}

local function CreateDrawings(p)
    Cache[p] = {
        MainBox = Drawing.new("Square"), InOutline = Drawing.new("Square"), OutOutline = Drawing.new("Square"),
        Healthbar = Drawing.new("Square"), HealthFill = Drawing.new("Square"),
        Nametag = Drawing.new("Text"), Distance = Drawing.new("Text")
    }
    local obj = Cache[p]
    obj.Nametag.Size = 16; obj.Nametag.Outline = true; obj.Nametag.Center = true; obj.Nametag.Color = Color3.new(1,1,1); obj.Nametag.Font = 2
    obj.Distance.Size = 14; obj.Distance.Outline = true; obj.Distance.Center = true; obj.Distance.Color = Color3.new(1,1,1); obj.Distance.Font = 2
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LP then CreateDrawings(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LP then CreateDrawings(p) end end)

RunService.RenderStepped:Connect(function()
    for p, obj in pairs(Cache) do
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hrp and hum and hum.Health > 0 then
            local topPos, topOnScreen = Camera:WorldToViewportPoint((char:GetPivot() * CFrame.new(0, char:GetExtentsSize().Y / 2 + 0.2, 0)).Position)
            local bottomPos, bottomOnScreen = Camera:WorldToViewportPoint((char:GetPivot() * CFrame.new(0, -char:GetExtentsSize().Y / 2 - 0.2, 0)).Position)
            
            if topOnScreen and bottomOnScreen then
                local sY = math.abs(topPos.Y - bottomPos.Y); local sX = sY * 0.6; local bX, bY = topPos.X - sX / 2, topPos.Y
                
                obj.MainBox.Visible = _G.SETTINGS.BoxVisible; obj.MainBox.Size = Vector2.new(sX, sY); obj.MainBox.Position = Vector2.new(bX, bY); obj.MainBox.Color = Color3.new(1,1,1)
                
                obj.Healthbar.Visible = _G.SETTINGS.HealthbarVisible; obj.Healthbar.Size = Vector2.new(4, sY); obj.Healthbar.Position = Vector2.new(bX - 6, bY); obj.Healthbar.Color = Color3.new(0,0,0)
                local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                obj.HealthFill.Visible = _G.SETTINGS.HealthbarVisible; obj.HealthFill.Size = Vector2.new(2, sY * hpPct); obj.HealthFill.Position = Vector2.new(bX - 5, bY + (sY * (1 - hpPct))); obj.HealthFill.Color = Color3.fromHSV(hpPct * 0.3, 1, 1)
                
                obj.Nametag.Visible = _G.SETTINGS.NametagsVisible; obj.Nametag.Position = Vector2.new(topPos.X, bY - 20); obj.Nametag.Text = p.Name .. " [" .. math.floor(hum.Health) .. "]"
                
                obj.Distance.Visible = _G.SETTINGS.DistanceVisible; obj.Distance.Position = Vector2.new(topPos.X, bY + sY + 5)
                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    obj.Distance.Text = math.floor((hrp.Position - LP.Character.HumanoidRootPart.Position).Magnitude) .. "m"
                end
            else for _, v in pairs(obj) do v.Visible = false end end
        else for _, v in pairs(obj) do v.Visible = false end end
    end
end)
