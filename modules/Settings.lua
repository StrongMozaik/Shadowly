-- [[ SHADOW HUB: DEFAULT SETTINGS ]] --
_G.SETTINGS = {
    AimbotEnabled = true,
    AimSmooth = 0.85, -- Zwiększone wygładzenie
    FOV = 95,         -- Zmniejszony zasięg koła celownika
    AimKey = Enum.UserInputType.MouseButton1,
    AimIsMouse = true,
    HeadOffset = 0.28,
    BoxVisible = true,
    SkeletonEnabled = false, -- Wyłączone na start
    TracersEnabled = true,
    NametagsVisible = true,
    HealthbarVisible = true,
    DistanceVisible = false,
    AccentColor = Color3.fromRGB(255, 60, 60),
    MenuKey = Enum.KeyCode.Insert
}

return _G.SETTINGS
