-- [[ SHADOW HUB: MAIN LOADER ]] --
local base_url = "https://raw.githubusercontent.com/StrongMozaik/Shadowly/main/"

print("Shadow Hub: Loading...")

-- 1. Załaduj ustawienia
loadstring(game:HttpGet(base_url .. "modules/settings.lua"))()

-- 2. Załaduj logikę i ESP
loadstring(game:HttpGet(base_url .. "modules/logic.lua"))()

-- 3. Załaduj Menu UI (jeśli masz osobny plik)
-- loadstring(game:HttpGet(base_url .. "modules/ui.lua"))()

print("Shadow Hub: Successfully Loaded!")
