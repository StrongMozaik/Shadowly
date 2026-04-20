local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
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
    -- Ustawienia tekstu 1:1
    obj.Nametag.Size = 14; obj.Nametag.Outline = true; obj.Nametag.Center = true; obj.Nametag.Color = Color3.new(1,1,1)
    obj.Distance.Size = 13; obj.Distance.Outline = true; obj.Distance.Center = true; obj.Distance.Color = Color3.new(1,1,1)
    
    -- Ustawienia obramowań Boxa
    obj.InOutline.Thickness = 1; obj.InOutline.Color = Color3.new(0,0,0)
    obj.OutOutline.Thickness = 1; obj.OutOutline.Color = Color3.new(0,0,0)
    obj.MainBox.Thickness = 1
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
            local hrpPos, hrpOnScreen = Camera:WorldToViewportPoint(hrp.Position)

            if hrpOnScreen and topOnScreen and bottomOnScreen then
                local sY = math.abs(topPos.Y - bottomPos.Y)
                local sX = sY * 0.6
                local bX, bY = hrpPos.X - sX / 2, topPos.Y
                
                -- BOX Z OBRAMOWANIEM (Outlines)
                local visible = _G.SETTINGS.BoxVisible
                obj.MainBox.Visible = visible
                obj.InOutline.Visible = visible
                obj.OutOutline.Visible = visible
                
                if visible then
                    obj.MainBox.Size = Vector2.new(sX, sY); obj.MainBox.Position = Vector2.new(bX, bY); obj.MainBox.Color = Color3.new(1,1,1)
                    obj.InOutline.Size = Vector2.new(sX - 2, sY - 2); obj.InOutline.Position = Vector2.new(bX + 1, bY + 1)
                    obj.OutOutline.Size = Vector2.new(sX + 2, sY + 2); obj.OutOutline.Position = Vector2.new(bX - 1, bY - 1)
                end
                
                -- PASEK ŻYCIA 1:1
                obj.Healthbar.Visible = _G.SETTINGS.HealthbarVisible
                obj.HealthFill.Visible = _G.SETTINGS.HealthbarVisible
                if _G.SETTINGS.HealthbarVisible then
                    local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    obj.Healthbar.Size = Vector2.new(4, sY); obj.Healthbar.Position = Vector2.new(bX - 6, bY); obj.Healthbar.Color = Color3.new(0,0,0); obj.Healthbar.Filled = true
                    obj.HealthFill.Size = Vector2.new(2, (sY - 2) * hpPct); obj.HealthFill.Position = Vector2.new(bX - 5, bY + 1 + (sY - 2) * (1 - hpPct))
                    obj.HealthFill.Color = Color3.fromHSV(hpPct * 0.3, 1, 1); obj.HealthFill.Filled = true
                end
                
                -- NAZWY + HP 1:1
                obj.Nametag.Visible = _G.SETTINGS.NametagsVisible
                if _G.SETTINGS.NametagsVisible then
                    obj.Nametag.Position = Vector2.new(hrpPos.X, bY - 18)
                    obj.Nametag.Text = p.Name .. " | " .. math.floor(hum.Health) .. "HP"
                end
                
                -- ODLEGŁOŚĆ 1:1
                obj.Distance.Visible = _G.SETTINGS.DistanceVisible
                if _G.SETTINGS.DistanceVisible then
                    obj.Distance.Position = Vector2.new(hrpPos.X, bY + sY + 2)
                    obj.Distance.Text = "[" .. math.floor(hrpPos.Z * 0.3) .. "m]"
                end
            else
                for _, v in pairs(obj) do v.Visible = false end
            end
        else
            for _, v in pairs(obj) do v.Visible = false end
        end
    end
end)
