local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function ApplyNeon(model)
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            -- Ustawienie materiału ForceField daje efekt mocnego świecenia (Neon)
            part.Material = _G.SETTINGS.HandChamsEnabled and Enum.Material.ForceField or Enum.Material.Plastic
            part.Color = _G.SETTINGS.HandChamsEnabled and _G.SETTINGS.ChamsColor or part.Color
        end
    end
end

RunService.RenderStepped:Connect(function()
    local viewmodel = Camera:FindFirstChild("Viewmodel") or Camera:FindFirstChild("FPS_Viewmodel")
    if viewmodel then
        ApplyNeon(viewmodel)
    end
end)

return true
