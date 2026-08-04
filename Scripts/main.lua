local UEHelpers = require("UEHelpers.UEHelpers")
print("--------------------------------")
print("STONEMACHIA CHEAT MOD LOADED")
print("Commands:")
print("enable_cheats [true] - activate all cheats. Pass 'true' to skip queen (stay as pawn)")
print("god_player  - DamageMultiplier=0. Persists through death")
print("queen       - queen form, vulnerable (1-2 hits to die). Persists through death/checkpoints")
print("queen_off   - revert to pawn form")
print("parry_on_hit - auto-parry every hit in any form. Persists through death/checkpoints")
print("parry_off   - deactivate parry on hit")
print("more_mana   - set player mana to 9999")
print("set_level <n> - set player level (session only - resets on game restart)")
print("jumps <n>   - set jump count")
print("spawn_topini <n> - spawn n rat minions")
print("cheat_mod   - show this command list in the console at any time")
print("--------------------------------")

local queenActivated      = false
local parryOnHitActivated = false
local godPlayerActivated  = false
local jumpsEnabled        = false
local jumps               = 2
local parryOnHitHandle    = nil
local moreManaActivated   = false
local playerSessionLevel  = nil

local function parryOnHitOn(Ar)
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
    if Ar then Ar:Log("Parry on hit: ON") end
end

local function parryOnHitOff(Ar)
    parryOnHitActivated = false
    if parryOnHitHandle then
        CancelDelayedAction(parryOnHitHandle)
        parryOnHitHandle = nil
    end
    local p = UEHelpers.GetPlayer()
    if p and p:IsValid() then p['iframe+'] = false end
    print("Parry on hit: OFF")
    if Ar then Ar:Log("Parry on hit: OFF") end
end

local function godPlayerOn(Ar)
    godPlayerActivated = true
    local p = UEHelpers.GetPlayer()
    if p then
        p.DamageMultiplier = 0
        p.DamageBaseMultiplier = 0
        print("God player: ON")
        if Ar then Ar:Log("God player: ON") end
    end
end

local function jumpsOn(Ar)
    jumpsEnabled = true
    local p = UEHelpers.GetPlayer()
    if p then
        p.JumpMaxCount = jumps
        local msg = "Jumps set to: " .. tostring(p.JumpMaxCount)
        print(msg)
        if Ar then Ar:Log(msg) end
    end
end

local function queenOn(Ar)
    queenActivated = true
    local p = UEHelpers.GetPlayer()
    if p then
        p['diventa regina No level']()
        p.bCanBeDamaged = true
        print("Queen: ON (1-2 hits to die)")
        if Ar then Ar:Log("Queen: ON (1-2 hits to die)") end
    end
end

local function playerMaxMana(max_mana, Ar)
    moreManaActivated = true
    local p = UEHelpers.GetPlayer()
    if p then
        p['Max Mana'] = max_mana
        p.mana = max_mana
        print("Mana set to: " .. tostring(max_mana))
        if Ar then Ar:Log("Mana set to: " .. tostring(max_mana)) end
    end
end

local function setPlayerSessionLevel(level, Ar)
    playerSessionLevel = level
    local p = UEHelpers.GetPlayer()
    if p then
        local bpacStats = p.BPAC_PlayerStats
        if bpacStats then
            bpacStats.PlayerLvl = level
            bpacStats:SavePlayerStats()
            print("Level set to: " .. tostring(level))
            if Ar then Ar:Log("Level set to: " .. tostring(level)) end
        end
    end
end

local function spawnTopini(times_to_spawn, Ar)
    local p = UEHelpers.GetPlayer()
    if p then
        for i = 1, times_to_spawn do
            p["spawn topini"]()
            print("Topini spawned: " .. tostring(i))
            if Ar then Ar:Log("Topini spawned: " .. tostring(i)) end
        end
    end
end

-- cheat mod help cmd
RegisterConsoleCommandHandler("cheat_mod", function(FullCommand, Paramaters, Ar)
    Ar:Log("Commands:")
    Ar:Log("enable_cheats [true] - activate all cheats. Pass 'true' to skip queen (stay as pawn)")
    Ar:Log("god_player  - DamageMultiplier=0. Persists through death")
    Ar:Log("queen       - queen form, vulnerable (1-2 hits to die). Persists through death/checkpoints")
    Ar:Log("queen_off   - revert to pawn form")
    Ar:Log("parry_on_hit - auto-parry every hit in any form. Persists through death/checkpoints")
    Ar:Log("parry_off   - deactivate parry on hit")
    Ar:Log("more_mana   - set player mana to 9999")
    Ar:Log("set_level <n> - set player level (session only - resets on game restart)")
    Ar:Log("jumps <n>   - set jump count")
    Ar:Log("spawn_topini <n> - spawn n rat minions")
    Ar:Log("cheat_mod - show this help")
    return true
end)

RegisterConsoleCommandHandler("god_player", function(FullCommand, Paramaters, Ar)
    godPlayerOn(Ar)
    return true
end)

RegisterConsoleCommandHandler("jumps", function(FullCommand, Paramaters, Ar)
    jumpsEnabled = true
    jumps = tonumber(Paramaters[1]) or 2
    jumpsOn(Ar)
    return true
end)

RegisterConsoleCommandHandler("set_level", function(FullCommand, Paramaters, Ar)
    local level = tonumber(Paramaters[1])
    if not level then
        Ar:Log("Usage: set_level <number>")
        return true
    end
    setPlayerSessionLevel(level, Ar)
    return true
end)

RegisterConsoleCommandHandler("queen", function(FullCommand, Paramaters, Ar)
    queenOn(Ar)
    return true
end)

RegisterConsoleCommandHandler("queen_off", function(FullCommand, Paramaters, Ar)
    queenActivated = false
    local p = UEHelpers.GetPlayer()
    if p then
        p["diventa pedone"]()
        p.bCanBeDamaged = true
        print("Queen: OFF")
        if Ar then Ar:Log("Queen: OFF") end
    end
    return true
end)

RegisterConsoleCommandHandler("parry_on_hit", function(FullCommand, Paramaters, Ar)
    parryOnHitOn(Ar)
    return true
end)

RegisterConsoleCommandHandler("parry_off", function(FullCommand, Paramaters, Ar)
    parryOnHitOff(Ar)
    return true
end)

RegisterConsoleCommandHandler("spawn_topini", function(FullCommand, Paramaters, Ar)
    local times_to_spawn = tonumber(Paramaters[1]) or 1
    spawnTopini(times_to_spawn, Ar)
    return true
end)

-- more player mana cmd
RegisterConsoleCommandHandler("more_mana", function(FullCommand, Paramaters, Ar)
    playerMaxMana(9999, Ar)
    return true
end)

-- enable all cheats
RegisterConsoleCommandHandler("enable_cheats", function(FullCommand, Paramaters, Ar)
    local skip_queen = Paramaters[1] == "true"
    if not skip_queen then
        queenOn(Ar)
    end
    parryOnHitOn(Ar)
    godPlayerOn(Ar)
    jumpsOn(Ar)
    spawnTopini(2, Ar)
    playerMaxMana(9999, Ar)
    if Ar then Ar:Log("All cheats enabled") end
    return true
end)

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
        ExecuteInGameThreadWithDelay(3000, function() godPlayerOn() end)
    end
    if jumpsEnabled then
        ExecuteInGameThreadWithDelay(3000, function() jumpsOn() end)
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
