local ModMenu = require("ModMenu.ModMenu")
local UEHelpers = require("UEHelpers.UEHelpers")

print("--------------------------------")
print("StoneMachia Cheat Mod")
print("Press F6 to open the cheat menu")
print("--------------------------------")

ModMenu.Init({
    title = "StoneMachia Cheats",
    key = Key.F6,
    keyHint = "F6",
    dock = "right",
    fontTitle = 22,
    fontHint = 14,
    fontItem = 16,
    fontSection = 18,
    fontDropdown = 16,
})

local parryOnHitHandle            = nil
local parryOnHitActivated         = false
local queenActivated              = false
local godPlayerActivated          = false
local jumpsEnabled                = false
local jumpsCount                  = 2
local defaultDamageMultiplier     = nil
local defaultDamageBaseMultiplier = nil
local moreManaActivated           = false
local playerSessionLevel          = nil
local defaultMana                 = nil
local defaultMaxMana              = nil
local playerDefaultLevel          = nil


local function setPlayerSessionLevel(level)
    playerSessionLevel = level
    local p = UEHelpers.GetPlayer()
    if p then
        local bpacStats = p.BPAC_PlayerStats
        if bpacStats then
            if not playerDefaultLevel then
                playerDefaultLevel = bpacStats.PlayerLvl
            end
            bpacStats.PlayerLvl = level
            bpacStats:SavePlayerStats()
            print("Level set to: " .. tostring(level))
        end
    end
end

local function godPlayer(on)
    local p = UEHelpers.GetPlayer()
    if p then
        if not defaultDamageMultiplier then
            defaultDamageMultiplier = p.DamageMultiplier
            defaultDamageBaseMultiplier = p.DamageBaseMultiplier
        end
        p.DamageMultiplier = on and 0 or defaultDamageMultiplier
        p.DamageBaseMultiplier = on and 0 or defaultDamageBaseMultiplier
        print("God player: " .. (on and "ON" or "OFF"))
    end
end


local function playerMaxMana(max_mana)
    local p = UEHelpers.GetPlayer()
    if p then
        if not defaultMana then
            defaultMana = p.mana
            defaultMaxMana = p['Max Mana']
        end
        p['Max Mana'] = max_mana
        p.mana = max_mana
        print("Mana set to: " .. tostring(max_mana))
    end
end



local function parryOnHitOn()
    parryOnHitActivated = true
    if not parryOnHitHandle then
        parryOnHitHandle = LoopInGameThreadWithDelay(16, function()
            if parryOnHitActivated then
                local p = UEHelpers.GetPlayer()
                if p then p['iframe+'] = true end
            end
        end)
    end
    print("Parry on hit: ON")
end

local function parryOnHitOff()
    parryOnHitActivated = false
    if parryOnHitHandle then
        CancelDelayedAction(parryOnHitHandle)
        parryOnHitHandle = nil
    end
    local p = UEHelpers.GetPlayer()
    if p and p:IsValid() then p['iframe+'] = false end
    print("Parry on hit: OFF")
end

local function spawnTopini(times_to_spawn)
    local p = UEHelpers.GetPlayer()
    if p then
        for i = 1, times_to_spawn do
            p["spawn topini"]()
            print("Topini spawned: " .. tostring(i))
        end
    end
end

local function queenOn()
    local p = UEHelpers.GetPlayer()
    if p then
        p['diventa regina No level']()
        p.bCanBeDamaged = true
        print("Queen: ON (1-2 hits to die)")
    end
end

local function queenOff()
    local p = UEHelpers.GetPlayer()
    if p then
        p["diventa pedone"]()
        p.bCanBeDamaged = true
        print("Queen: OFF")
    end
end


local function jumps()
    local p = UEHelpers.GetPlayer()
    if p then
        p.JumpMaxCount = jumpsEnabled and jumpsCount or 1
        local msg = "Jumps set to: " .. tostring(p.JumpMaxCount)
        print(msg)
    end
end

ModMenu.Register({
    id = "Cheats",
    title = "Cheats",
    items = {
        -- jump checkbox
        {
            type = "checkbox",
            id = "jumps",
            label = "Jumps",
            default = false,
            onChange = function(checked)
                jumpsEnabled = checked
                jumps()
            end,
        },
        {
            type = "checkbox",
            id = "godPlayer",
            label = "God Player",
            default = false,
            onChange = function(checked)
                godPlayerActivated = checked
                godPlayer(checked)
            end,
        },
        {
            type = "checkbox",
            id = "parryOnHit",
            label = "Parry on hit",
            default = false,
            onChange = function(checked)
                if checked then
                    parryOnHitOn()
                else
                    parryOnHitOff()
                end
            end,
        },
        {
            type = "checkbox",
            id = "queen",
            label = "Queen",
            default = false,
            onChange = function(checked)
                queenActivated = checked
                if checked then
                    queenOn()
                else
                    queenOff()
                end
            end,
        },
        {
            type = "checkbox",
            id = "moreMana",
            label = "More Mana",
            default = false,
            onChange = function(checked)
                moreManaActivated = checked
                if checked then
                    playerMaxMana(9999)
                elseif defaultMaxMana then
                    playerMaxMana(defaultMaxMana)
                end
            end,
        },
        {
            type = "button",
            id = "spawnTopini",
            label = "Spawn Topini",
            onClick = function()
                spawnTopini(1)
            end,
        },
        {
            type = "dropdown",
            id = "playerLevel",
            label = "Player Level",
            options = {
                { label = "Default", value = playerDefaultLevel or 0 },
                { label = "10",      value = 10 },
                { label = "20",      value = 20 },
                { label = "30",      value = 30 },
                { label = "40",      value = 40 },
                { label = "50",      value = 50 },
                { label = "60",      value = 60 },
                { label = "70",      value = 70 },
                { label = "80",      value = 80 },
                { label = "90",      value = 90 },
                { label = "100",     value = 100 },
                { label = "999",     value = 999 },
                { label = "9999",    value = 9999 },
                { label = "99999",   value = 99999 },
                { label = "MAX",     value = 999999 },
            },
            default = playerDefaultLevel or 0,
            onChange = function(value)
                local level = tonumber(value)
                if level then
                    setPlayerSessionLevel(level)
                end
            end,
        },
        {
            type = "dropdown",
            id = "jumpCount",
            label = "Jump Count - Only works if Jumps is enabled",
            options = {
                { label = "2",   value = 2 },
                { label = "4",   value = 4 },
                { label = "8",   value = 8 },
                { label = "16",  value = 16 },
                { label = "32",  value = 32 },
                { label = "64",  value = 64 },
                { label = "999", value = 999 },
            },
            default = 2,
            onChange = function(value)
                local n = tonumber(value)
                if not n then return end
                jumpsCount = n
                if jumpsEnabled then
                    jumps()
                end
            end,
        },
    },
})


RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    if queenActivated then
        ExecuteInGameThreadWithDelay(3000, function() queenOn() end)
    end
    if parryOnHitActivated then
        if parryOnHitHandle then
            CancelDelayedAction(parryOnHitHandle)
            parryOnHitHandle = nil
        end
        ExecuteInGameThreadWithDelay(3000, function() parryOnHitOn() end)
    end
    if godPlayerActivated then
        ExecuteInGameThreadWithDelay(3000, function() godPlayer(true) end)
    end
    if jumpsEnabled then
        ExecuteInGameThreadWithDelay(3000, function() jumps() end)
    end
    if moreManaActivated then
        ExecuteInGameThreadWithDelay(3000, function() playerMaxMana(9999) end)
    end
    if playerSessionLevel then
        ExecuteInGameThreadWithDelay(3000, function() setPlayerSessionLevel(playerSessionLevel) end)
    end
end)

local checkpointHookRegistered = false
NotifyOnNewObject(
    "/Game/personaggio/NUOVISSIMOOMINO/Checkpoint/pedana_checkpoint.pedana_checkpoint_C",
    function(newCheckpoint)
        if checkpointHookRegistered then return end
        checkpointHookRegistered = true
        RegisterHook(
            "/Game/personaggio/NUOVISSIMOOMINO/Checkpoint/pedana_checkpoint.pedana_checkpoint_C:BndEvt__pedana_checkpoint_Sphere_K2Node_ComponentBoundEvent_1_ComponentEndOverlapSignature__DelegateSignature",
            function(self)
                if parryOnHitActivated and parryOnHitHandle then
                    local p = UEHelpers.GetPlayer()
                    if p and p:IsValid() then p['iframe+'] = false end
                    parryOnHitActivated = false
                    CancelDelayedAction(parryOnHitHandle)
                    parryOnHitHandle = nil
                    ExecuteInGameThreadWithDelay(3000, function() parryOnHitOn() end)
                end
                if queenActivated then
                    ExecuteInGameThreadWithDelay(3000, function() queenOn() end)
                end
            end)
    end)
