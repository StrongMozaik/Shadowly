-- [[ SHADOW HUB: OFFICIAL LOADER ]] --
local RawBase = "https://raw.githubusercontent.com/StrongMozaik/Shadowly/main/modules/"

local function Load(module)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(RawBase .. module .. ".lua"))()
    end)
    if not success then warn("Shadowly: Error loading " .. module .. ": " .. result) end
end

print("Shadowly: Initializing...")
Load("Settings") -- Najpierw konfiguracja
Load("Aimbot")   -- Potem system celowania
Load("ESP")      -- Potem wizualizacje
Load("Gui")      -- Na końcu menu
print("Shadowly: Successfully Loaded!")
