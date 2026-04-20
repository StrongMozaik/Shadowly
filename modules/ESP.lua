-- [[ SHADOW HUB: ESP MODULE (ULTRA FORCE WHITE TEXT) ]] --
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Cache = {}

local function CreateDrawings(p)
    local obj = {
        MainBox = Drawing.new("Square"), 
        InOutline = Drawing.new("Square"), 
        OutOutline = Drawing.new("Square"),
        Healthbar = Drawing.new("Square"), 
        HealthFill = Drawing.new("Square"),
        Nametag = Drawing.new("Text"), 
        Distance = Drawing.new("Text")
    }
    
    -- Konfiguracja bazowa
    obj.Nametag.Size = 14
    obj.Nametag.Outline = true
    obj.Nametag.Center = true
    obj.Nametag.Visible = false
    
    obj.Distance.Size = 13
    obj.Distance.Outline = true
    obj.Distance.Center = true
    obj.Distance.Visible = false

    Cache[p] = obj
end

for _, p in pairs(Players:GetPlayers()) do if p ~= LP then CreateDrawings(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LP then CreateDrawings(p) end end)
Players.PlayerRemoving:Connect(function(p) 
    if Cache[p] then 
        for _, v in pairs(Cache[p]) do v:Remove() end 
        Cache[p] = nil 
    end 
end)

RunService.RenderStepped:Connect(function()
    for p, obj in pairs(Cache) do
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hrp and hum and hum.Health > 0 then
            local topPos, topOnScreen = Camera:WorldToViewportPoint((char:GetPivot() * CFrame.new(0, char:GetExtentsSize().Y/2 + 0.2, 0)).Position)
            local bottomPos, bottomOnScreen = Camera:WorldToViewportPoint((char:GetPivot() * CFrame.new(0, -char:GetExtentsSize().Y/2 - 0.2, 0)).Position)
            local hrpPos, hrpOnScreen = Camera:WorldToViewportPoint(hrp.Position)

            if hrpOnScreen and topOnScreen and bottomOnScreen then
                local sY = math.abs(topPos.Y - bottomPos.Y)
                local sX, bX, bY = sY * 0.6, hrpPos.X - (sY * 0.6) / 2, topPos.Y
                
                -- Rysowanie Boxa
                if _G.SETTINGS.BoxVisible then
                    obj.MainBox.Size = Vector2.new(sX, sY); obj.MainBox.Position = Vector2.new(bX, bY); obj.MainBox.Color = Color3.new(1,1,1); obj.MainBox.Visible = true
                    obj.InOutline.Size = Vector2.new(sX-2, sY-2); obj.InOutline.Position = Vector2.new(bX+1, bY+1); obj.InOutline.Color = Color3.new(0,0,0); obj.InOutline.Visible = true
                    obj.OutOutline.Size = Vector2.new(sX+2, sY+2); obj.OutOutline.Position = Vector2.new(bX-1, bY-1); obj.OutOutline.Color = Color3.new(0,0,0); obj.OutOutline.Visible = true
                else
                    obj.MainBox.Visible = false; obj.InOutline.Visible = false; obj.OutOutline.Visible = false
                end
                
                -- Pasek życia
                if _G.SETTINGS.HealthbarVisible then
                    local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    obj.Healthbar.Size = Vector2.new(4, sY); obj.Healthbar.Position = Vector2.new(bX-6, bY); obj.Healthbar.Color = Color3.new(0,0,0); obj.Healthbar.Filled = true; obj.Healthbar.Visible = true
                    obj.HealthFill.Size = Vector2.new(2, (sY-2) * pct); obj.HealthFill.Position = Vector2.new(bX-5, bY+1+(sY-2)*(1-pct)); obj.HealthFill.Color = Color3.fromHSV(pct*0.3, 1, 1); obj.HealthFill.Filled = true; obj.HealthFill.Visible = true
                else
                    obj.Healthbar.Visible = false; obj.HealthFill.Visible = false
                end
                
                -- [[ NAPRAWA KOLORU TEKSTU ]] --
                if _G.SETTINGS.NametagsVisible then
                    obj.Nametag.Text = p.Name .. " | " .. math.floor(hum.Health) .. "HP"
                    obj.Nametag.Position = Vector2.new(hrpPos.X, bY-18)
                    obj.Nametag.Color = Color3.fromRGB(255, 255, 255) -- WYMUSZANIE BIELI
                    obj.Nametag.OutlineColor = Color3.fromRGB(0, 0, 0)
                    obj.Nametag.Visible = true
                else
                    obj.Nametag.Visible = false
                end
                
                if _G.SETTINGS.DistanceVisible then
                    local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    obj.Distance.Text = dist .. "m"
                    obj.Distance.Position = Vector2.new(hrpPos.X, bottomPos.Y + 5)
                    obj.Distance.Color = Color3.fromRGB(255, 255, 255) -- WYMUSZANIE BIELI
                    obj.Distance.Visible = true
                else
                    obj.Distance.Visible = false
                end
            else 
                for _,v in pairs(obj) do v.Visible = false end 
            end
        else 
            for _,v in pairs(obj) do v.Visible = false end 
        end
    end
end)

return true
