-- [[ SHADOW HUB: OFFICIAL LOADER ]] --
local RawBase = "https://raw.githubusercontent.com/StrongMozaik/Shadowly/main/modules/"

local function Load(module)
    local url = RawBase .. module .. ".lua"
    local success, source = pcall(function() return game:HttpGet(url) end)
    
    if success then
        local func, err = loadstring(source)
        if func then
            return func()
        else
            warn("Shadowly: Blad kompilacji " .. module .. ": " .. err)
        end
    else
        warn("Shadowly: Nie znaleziono modulu " .. module)
    end
end

print("Shadowly: Inicjalizacja...")
Load("Settings")
Load("Aimbot")
Load("ESP")
Load("SkeletonESP")
Load("Tracers") -- NOWOŚĆ
Load("Gui")
print("Shadowly: Zaladowano wszystko!")
