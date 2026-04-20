local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

RunService.RenderStepped:Connect(function()
    if _G.SETTINGS.StretchedRes then
        -- Efekt 4:3 rozciągniętego
        Camera.FieldOfView = 110
    else
        -- Standardowy widok (możesz zmienić na 70/80/90 wg uznania)
        Camera.FieldOfView = 80
    end
end)

return true
