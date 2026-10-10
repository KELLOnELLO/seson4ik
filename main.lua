local function safeLoad(url, name)
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if ok and result then
        print("[Void] Loaded:", name)
        return result
    else
        warn("[Void] Failed to load:", name, result)
        return nil
    end
end

local Neverlose = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/seson4ik/main/Neverlose.lua", "Neverlose")
local AutoFarm  = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/autofarm.lua", "AutoFarm")
local Invis     = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/invis.lua", "Invis")
local SF        = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/sf.lua", "SF")
local Weather   = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/weather.lua", "Weather")
local Visuals   = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/visuals.lua", "Visuals")
local PlayerMod = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/player.lua", "PlayerMod")

if not Neverlose then
    warn("[Void] Neverlose library failed to load. Aborting.")
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Safe init helpers
local function try(fn, name)
    local ok, err = pcall(fn)
    if not ok then
        warn("[Void] Init failed:", name, err)
    end
    return ok
end

-- Init modules BEFORE creating window
local farm, invis, sf, weather, visuals, playerMod

if AutoFarm then
    try(function() farm = AutoFarm.new() end, "farm.new")
    if farm then
        try(function() farm:LoadConfig() end, "farm:LoadConfig")
        try(function() farm:SkipLoading() end, "farm:SkipLoading")
        try(function() farm:EnableKeyBypass() end, "farm:EnableKeyBypass")
        try(function() farm:SetCharacterRespawnHandler() end, "farm:SetCharacterRespawnHandler")
    end
end

if Invis then
    try(function() invis = Invis.new() end, "invis.new")
    if invis then
        try(function() invis:HookRespawn() end, "invis:HookRespawn")
    end
end

if SF then
    try(function() sf = SF.new() end, "sf.new")
    if sf then
        try(function() sf:Setup() end, "sf:Setup")
    end
end

if Weather then
    try(function() weather = Weather.new() end, "weather.new")
    if weather then
        try(function() weather:WaitForWeatherValue(10) end, "weather:WaitForWeatherValue")
    end
end

if Visuals then
    try(function() visuals = Visuals.new() end, "visuals.new")
end

if PlayerMod then
    try(function() playerMod = PlayerMod.new() end, "playerMod.new")
    if playerMod then
        try(function() playerMod:HookRespawn() end, "playerMod:HookRespawn")
    end
end

-- NOW create window
print("[Void] Creating window...")
local win = Neverlose:CreateWindow("Neverlose")
print("[Void] Window created")

-- ==================== FARM TAB ====================
if farm then
    local farmTab = win:CreateTab("Farm")
    local farmSec = farmTab:AddSection("Autofarm")

    farmSec:AddToggle("Autofarm", false, function(state)
        if state then farm:Start() else farm:Stop() end
    end)

    farmSec:AddToggle("Noclip", true, function(state)
        farm:SetNoclip(state)
    end)

    farmSec:AddToggle("Camera Noclip", false, function(state)
        farm:SetCameraNoclip(state)
    end)

    farmSec:AddToggle("Random TP", true, function(state)
        farm:SetConfig("RandomTP", state)
    end)

    farmSec:AddToggle("Auto Sell", farm.Config.AutoSell, function(state)
        farm:SetConfig("AutoSell", state)
        farm:SaveConfig()
    end)

    farmSec:AddToggle("Server Hop", farm.Config.ServerHop, function(state)
        farm:SetConfig("ServerHop", state)
        farm:SaveConfig()
        if state then farm:StartServerHopLoop() else farm:StopServerHopLoop() end
    end)

    farmSec:AddSlider("TP Offset", 0, 15, farm.Config.TPOffset, function(v)
        farm:SetConfig("TPOffset", v)
        farm:SaveConfig()
    end)

    farmSec:AddSlider("E Hold Time (ms/100)", 0, 50, math.floor(farm.Config.EHoldTime * 10), function(v)
        farm:SetConfig("EHoldTime", v / 10)
        farm:SaveConfig()
    end)

    farmSec:AddSlider("E Range", 10, 200, farm.Config.ERange, function(v)
        farm:SetConfig("ERange", v)
        farm:SaveConfig()
    end)

    farmSec:AddSlider("TP Speed (ms/10)", 1, 50, math.floor(farm.Config.TPSpeed * 10), function(v)
        farm:SetConfig("TPSpeed", v / 10)
        farm:SaveConfig()
    end)

    farmSec:AddButton("TP to Merchant", function()
        farm:TeleportToMerchant()
    end)

    farmSec:AddButton("Save Config", function()
        farm:SaveConfig()
    end)

    -- OPTIMIZATION
    local optTab = win:CreateTab("Optimization")
    local optSec = optTab:AddSection("Performance")

    optSec:AddSlider("FPS Cap", 30, 240, farm.Config.FPSCap, function(v)
        farm:SetConfig("FPSCap", v)
        farm:ApplyFPSCap(v)
        farm:SaveConfig()
    end)

    optSec:AddSlider("Render Distance", 1, 20, farm.Config.RenderDistance, function(v)
        farm:SetConfig("RenderDistance", v)
        farm:ApplyRenderDistance(v)
        farm:SaveConfig()
    end)

    optSec:AddToggle("Remove Trees/Bushes", farm.Config.RemoveTrees, function(state)
        farm:SetConfig("RemoveTrees", state)
        if state then farm:RemoveTreesAndBushes() end
        farm:SaveConfig()
    end)
end

-- ==================== VISUALS TAB ====================
if visuals then
    local visualTab = win:CreateTab("Visuals")
    local visSec = visualTab:AddSection("Players")

    visSec:AddToggle("Player ESP", false, function(state)
        visuals:SetESP(state)
    end)

    visSec:AddToggle("3D OFF", false, function(state)
        visuals:Set3DOff(state)
    end)
end

-- ==================== PLAYER TAB ====================
if playerMod or invis then
    local playerTab = win:CreateTab("Player")

    if playerMod then
        local plSec = playerTab:AddSection("Movement")

        plSec:AddToggle("Noclip", false, function(state)
            playerMod:SetNoclip(state)
        end)

        plSec:AddToggle("Fly", false, function(state)
            playerMod:SetFly(state)
        end)

        plSec:AddSlider("Fly Speed (x10)", 1, 100, 10, function(v)
            playerMod:SetFlySpeed(v / 10)
        end)

        plSec:AddToggle("Click TP (Tool)", false, function(state)
            playerMod:SetClickTP(state)
        end)
    end

    if invis then
        local invisSec = playerTab:AddSection("Invisibility")

        invisSec:AddToggle("Invisible", false, function(state)
            invis:SetEnabled(state)
        end)

        invisSec:AddToggle("Red Glow", true, function(state)
            invis:SetGlow(state)
        end)

        invisSec:AddToggle("Ghost Walk", false, function(state)
            invis:SetGhostWalk(state)
        end)
    end
end

-- ==================== SF TAB ====================
if sf then
    local sfTab = win:CreateTab("SF")
    local sfSec = sfTab:AddSection("Selected Players")

    local playerNames = sf:GetPlayerNames()
    local selectedDropdownValue = playerNames[1] or ""

    sfSec:AddDropdown("Player", playerNames, playerNames[1] or "None", function(value)
        selectedDropdownValue = value
    end)

    sfSec:AddButton("Select", function()
        if selectedDropdownValue and selectedDropdownValue ~= "" then
            local list = sf:GetSelected()
            table.insert(list, selectedDropdownValue)
            sf:SetSelected(list)
        end
    end)

    sfSec:AddButton("Deselect", function()
        if selectedDropdownValue and selectedDropdownValue ~= "" then
            sf:Deselect(selectedDropdownValue)
        end
    end)

    sfSec:AddButton("Clear All", function()
        sf:ClearSelected()
    end)

    sfSec:AddButton("Apply Hitbox", function()
        for _, name in ipairs(sf:GetSelected()) do
            local plr = Players:FindFirstChild(name)
            if plr then sf:ApplyHitbox(plr) end
        end
    end)
end

-- ==================== WEATHER TAB ====================
if weather then
    local weatherTab = win:CreateTab("Weather")
    local weatherSec = weatherTab:AddSection("Weather")

    for _, weatherName in ipairs(weather:GetOptions()) do
        weatherSec:AddButton("Set " .. weatherName, function()
            weather:Set(weatherName)
        end)
    end

    weatherSec:AddButton("Cycle", function()
        weather:Cycle()
    end)
end

-- ==================== STATS TAB ====================
if farm then
    local statsTab = win:CreateTab("Stats")
    local statsSec = statsTab:AddSection("Session")

    local statsLabel = statsSec:AddLabel("Session", "Picked: 0 | TP: 0\nLast: -")

    local function refreshStats()
        local s = farm:GetStats()
        local text = string.format("Picked: %d | TP: %d\nLast: %s", s.totalPicked, s.totalTPs, s.lastPickedItem)
        statsLabel:SetText(text)
    end

    task.spawn(function()
        while true do
            pcall(refreshStats)
            task.wait(0.5)
        end
    end)

    farm:SetCallback("OnStatsUpdate", function()
        pcall(refreshStats)
        if visuals and visuals:Is3DOff() then
            visuals:Update3DOverlay(farm:GetStats(), farm:GetItemsListText())
        end
    end)

    farm:SetCallback("OnPickup", function()
        pcall(refreshStats)
        if visuals and visuals:Is3DOff() then
            visuals:Update3DOverlay(farm:GetStats(), farm:GetItemsListText())
        end
    end)
end

if visuals and farm then
    visuals:SetCallback("On3DCreate", function()
        visuals:Update3DOverlay(farm:GetStats(), farm:GetItemsListText())
    end)
end

print("[Void] Main loaded successfully")

-- Apply saved settings
if farm then
    try(function() farm:ApplyFPSCap(farm.Config.FPSCap) end, "ApplyFPSCap")
    try(function() farm:ApplyRenderDistance(farm.Config.RenderDistance) end, "ApplyRenderDistance")
    if farm.Config.RemoveTrees then try(function() farm:RemoveTreesAndBushes() end, "RemoveTrees") end
    if farm.Config.ServerHop then try(function() farm:StartServerHopLoop() end, "ServerHop") end
    if weather then try(function() farm:SetWeather(weather:GetCurrent() or "Sunny") end, "SetWeather") end
end
