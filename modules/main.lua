-- [[ SHADOW HUB: OFFICIAL LOADER ]] --
local RawBase = "https://raw.githubusercontent.com/StrongMozaik/Shadowly/main/modules/"

local function Load(module)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(RawBase .. module .. ".lua"))()
    end)
    if not success then warn("Shadowly: Błąd ładowania " .. module .. ": " .. result) end
end

print("Shadowly: Inicjalizacja...")
Load("Settings")
Load("Aimbot")
Load("ESP")
Load("Gui")
print("Shadowly: Załadowano pomyślnie!")
