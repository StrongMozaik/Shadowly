local RawBase = "https://raw.githubusercontent.com/StrongMozaik/Shadowly/main/modules/"

local function Load(module)
    local url = RawBase .. module .. ".lua"
    local success, source = pcall(function() return game:HttpGet(url) end)
    if success then
        local func = loadstring(source)
        if func then return func() end
    end
end

Load("Settings")
Load("Aimbot")
Load("ESP")
Load("SkeletonESP")
Load("Tracers")
Load("Gui")
