local Neverlose = loadstring(game:HttpGet("https://raw.githubusercontent.com/KELLOnELLO/seson4ik/main/Neverlose.lua"))()
local AutoFarm = loadstring(game:HttpGet("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/autofarm.lua"))()
local Invis = loadstring(game:HttpGet("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/invis.lua"))()
local SF = loadstring(game:HttpGet("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/sf.lua"))()
local Weather = loadstring(game:HttpGet("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/weather.lua"))()
local Visuals = loadstring(game:HttpGet("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/visuals.lua"))()
local PlayerMod = loadstring(game:HttpGet("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/player.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local win = Neverlose:CreateWindow("Void | YBA")

local farm = AutoFarm.new()
local invis = Invis.new()
local sf = SF.new()
local weather = Weather.new()
local visuals = Visuals.new()
local playerMod = PlayerMod.new()

farm:LoadConfig()
farm:SkipLoading()
farm:EnableKeyBypass()
farm:SetCharacterRespawnHandler()
weather:WaitForWeatherValue(10)
invis:HookRespawn()
sf:Setup()
playerMod:HookRespawn()

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

farmSec:AddSlider("E Hold Time", 0, 5, math.floor(farm.Config.EHoldTime * 10), function(v)
    farm:SetConfig("EHoldTime", v / 10)
    farm:SaveConfig()
end)

farmSec:AddSlider("E Range", 10, 200, farm.Config.ERange, function(v)
    farm:SetConfig("ERange", v)
    farm:SaveConfig()
end)

farmSec:AddSlider("TP Speed", 1, 50, math.floor(farm.Config.TPSpeed * 10), function(v)
    farm:SetConfig("TPSpeed", v / 10)
    farm:SaveConfig()
end)

farmSec:AddButton("TP to Merchant", function()
    farm:TeleportToMerchant()
end)

farmSec:AddButton("Save Config", function()
    farm:SaveConfig()
end)

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

local visualTab = win:CreateTab("Visuals")
local visSec = visualTab:AddSection("Players")

visSec:AddToggle("Player ESP", false, function(state)
    visuals:SetESP(state)
end)

visSec:AddToggle("3D OFF", false, function(state)
    visuals:Set3DOff(state)
end)

local playerTab = win:CreateTab("Player")
local plSec = playerTab:AddSection("Movement")

plSec:AddToggle("Noclip", false, function(state)
    playerMod:SetNoclip(state)
end)

plSec:AddToggle("Fly", false, function(state)
    playerMod:SetFly(state)
end)

plSec:AddSlider("Fly Speed", 1, 100, 10, function(v)
    playerMod:SetFlySpeed(v / 10)
end)

plSec:AddToggle("Click TP (Tool)", false, function(state)
    playerMod:SetClickTP(state)
end)

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

local sfTab = win:CreateTab("SF")
local sfSec = sfTab:AddSection("Selected Players")

local playerNames = sf:GetPlayerNames()
local selectedPlayers = {}

local function refreshPlayerList()
    local newNames = sf:GetPlayerNames()
    if #newNames > 0 then
        playerNames = newNames
    end
end

sfSec:AddDropdown("Player", playerNames, playerNames[1], function(value)
    refreshPlayerList()
end)

sfSec:AddButton("Select", function()
    if playerNames[1] then
        selectedPlayers = sf:GetSelected()
        table.insert(selectedPlayers, playerNames[1])
        sf:SetSelected(selectedPlayers)
    end
end)

sfSec:AddButton("Deselect", function()
    sf:Deselect(playerNames[1])
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

local weatherTab = win:CreateTab("Weather")
local weatherSec = weatherTab:AddSection("Weather")

local weatherOptions = weather:GetOptions()

for _, weatherName in ipairs(weatherOptions) do
    weatherSec:AddButton("Set " .. weatherName, function()
        weather:Set(weatherName)
    end)
end

weatherSec:AddButton("Cycle", function()
    weather:Cycle()
end)

local statsTab = win:CreateTab("Stats")
local statsSec = statsTab:AddSection("Session")

local statsLabel = nil

local function refreshStats()
    local s = farm:GetStats()
    local text = string.format(
        "Собрано: %d | ТП: %d\nПоследний: %s",
        s.totalPicked,
        s.totalTPs,
        s.lastPickedItem
    )
    if statsLabel then
        statsLabel:SetText(text)
    end
end

statsLabel = statsSec:AddLabel("Session", "Собрано: 0 | ТП: 0\nПоследний: —")

task.spawn(function()
    while true do
        refreshStats()
        task.wait(0.5)
    end
end)

farm:SetCallback("OnStatsUpdate", function()
    refreshStats()
end)

farm:SetCallback("OnPickup", function(name, stats)
    refreshStats()
end)

visuals:SetCallback("On3DUpdate", function(stats, itemsText)
    if visuals:Is3DOff() then
        visuals:Update3DOverlay(farm:GetStats(), farm:GetItemsListText())
    end
end)

farm:SetCallback("OnStatsUpdate", function()
    if visuals:Is3DOff() then
        visuals:Update3DOverlay(farm:GetStats(), farm:GetItemsListText())
    end
end)

if farm.Config.FPSCap then farm:ApplyFPSCap(farm.Config.FPSCap) end
if farm.Config.RenderDistance then farm:ApplyRenderDistance(farm.Config.RenderDistance) end
if farm.Config.RemoveTrees then farm:RemoveTreesAndBushes() end
if farm.Config.ServerHop then farm:StartServerHopLoop() end

farm:SetWeather(weather:GetCurrent() or "Sunny")

visuals:SetCallback("On3DCreate", function()
    if visuals:Is3DOff() then
        visuals:Update3DOverlay(farm:GetStats(), farm:GetItemsListText())
    end
end)
