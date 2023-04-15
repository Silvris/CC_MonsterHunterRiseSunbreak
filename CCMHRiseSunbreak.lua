CrowdControl = require "CCLuaBase"
local Success = 0
local Failure = 1
local Unavailable = 2
local Retry = 3
local Pause = 6
local Resumed = 7

local DisplayType = nil
local CurrentDisplay = nil
local SwitchViewTimer = -1.0
local StaminaDrainTimer= -1.0
local InvisibleTimer = -1.0
local IsInvis = false
--[[

Current List of Effects:
Invisible Player (30 sec)
Set HP to 1
Set Stamina to 0 - Need add 30 second timer
Nintendo Switch mode (not currently working - timers need looked into)
Attack Down -50% (Takes the current value of the hunter's attack, and cuts it by in half)
Defense Down -50% (Takes the current value of the hunter's defense, cuts it in half)
Explode the Hunter (An instant explosion on the hunter. -- blastblight, but no timer..just BOOM)
Bleed
Bloodblight
Poison
Deadly Posion
Dragonblight
Fireblight
Frenzy Virus
Hellfire
Iceblight
Bubbleblight
Noxious Poison
Stench
Thunderblight
Waterblight


#Buffs
_AtkUpBuffSecond (Can buff/debuff ATK hunter, no UI)
_AtkUpBuffSecondTimer
_AtkUpEcSecond (Can Buff Crits here 1-100%)
_AtkUpEcSecondTimer
_DefUpBuffSecond(Can buff/debuff DEF hunter, no UI)
_DefUpBuffSecondTimer

#WeaponTables
snow.player.PlayerUserDataChargeAxe


#Blights/Ailments
Fireblight _FireLDurationTimer
Waterblight _WaterLDurationTimer
Iceblight _IceLDurationTimer
Thunderblight _ThunderLDurationTimer
Dragonblight _DragonLDurationTimer
Poison
Noxious Poison
Deadly Poison
Blastblight _BombDurationTimer
Defense Down _DefenceDownDurationTimer
Resistance Down _ResistanceDownDurationTimer
Stench _StinkDurationTimer
Mild Bubbleblight
Severe Bubbleblight
Hellfireblight _OniBombDurationTimer
Bleeding
Frenzy Virus
Bloodblight _MysteryDebuffTimer

#Buffs
Attack Up
Element Attack Up
Affinity Up
Defense Up
Stamina Use Reduced
Gourmet Fish
Status Immunity (only to monsters)
Natural Healing Up
Blowback Negation
Divine Protection
Self-Improvement?
Knockback Negation
Earplugs(S)
Earplugs(L)
Tremor Negation
Wind Pressure Negation
Stun Negation
Blight Negation
Stamina Recovery Up
Sharpness Loss Reduction
Environmental Damage Negation
Infernal Melody
Status Effect Buildup Increased
Max Sharpness Up
Sharpness Regeneration
Sharpness Extension
Dango Defender

#Weapon Specific
(CB) Charge Phials (Yellow)
(CB) Charge Phials (Red)
(CB) Permanent Chainsaw (1 min)
(CB) Give/Take Red Shield
(CB) Give/Take Red Sword
(DB) Give/Remove Archdemon Gauge
(DB) Enter Demon Mode
(GL) Disable Wyvernfire
(GL) Enable Wyvernfire
(GL) Drain Bullets
(Ham) Change Charge Mode
(HBG) Drain Bullets
(HH) Reset Revolt Gauge
(IG) Give/Take Extract (Param:RWO)
(Lan) Give Guard Rage
(LBG) Drain Bullets
(LS) Give Spirit Gauge
(LS) Give Spirit Level
(SnS) Give Destroyer Oil
(SA) Give Phial Charge
(SA) Give Axe Boost (figure out proper names for these two)

(Blademaster) Drain Sharpness
(Blademaster) Sharpness Gauge Boost


Ideas:
PlayerQuestBase.setDie?
Add Wirebug PlayerBase.addHunterWireWildNum(1)
Remove Wirebug
Add Cart (not multiplayer safe)

figure out Stun, Paralysis, Sleep, Tremor (at worst, spawn something that inflicts it?)

Weapon Specific
(CB) Immediate Guard Point
(GL) Force Reload
(Lan) Give Ruten? dunno what that is tbh
(LBG/HBG) These have special gauges to separate them, give/take?
(CB/SA) MORPH!
--]]

function SendMessage(text)
        local chatman = sdk.get_managed_singleton("snow.gui.ChatManager")

        if not chatman then
            print("chatman fail")
            return
        end

        chatman:setChatNetworkInfomation(text,0,0,3,false)
end

local function CCSetPoison()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._PoisonDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._PoisonLv = 1
    player._PoisonDurationTimer = 5400.0
    return Success
end

local function CCSetNoxious()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._PoisonDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._PoisonLv = 2
    player._PoisonDurationTimer = 4000.0
    return Success
end

local function CCSetDeadly()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._PoisonDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._PoisonLv = 3
    player._PoisonDurationTimer = 3000.0
    return Success
end

local function CCSetBubbleM()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        print("isNotQuest")
        return Retry
    end
    local current = player._BubbleDamageTimer
    print(current)
    if current ~= 0.0 then
        local currentBubble = player._BubbleType
        if currentBubble > 1 then
            return Retry
        end
        player._BubbleType = currentBubble + 1
    else
        player._BubbleType = 1
    end
    player._BubbleDamageTimer = 5400.0
    return Success
end

local function CCSetBubbleL()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._BubbleDamageTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._BubbleType = 2
    player._BubbleDamageTimer = 5400.0
    return Success
end

local function CCSetBleed()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local currentBleed = player._BleedingDebuffTimer
    print(currentBleed)
    if currentBleed ~= 0.0 then
        return Retry
    end
    player:setBleeding(7500.0)
    return Success
end

local function CCSetVirus()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        print("Is not quest")
        return Retry
    end
    local cannotVirus = player._IsVirusLatency
    if cannotVirus then
        print("cannotVirus")
        return Retry
    end

    local frenzyblight = player._VirusOnsetTimer
    if frenzyblight > 0.0 then
        return Retry
    end

    player._IsVirusLatency = true
    return Success
end

local function CCMinSharpness()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local isGunner = player:call("checkGunner")
    if isGunner then
        return Unavailable
    end

    player:call("setSharpness",1.0)
    return Success
end

local function CCAddWirebug()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    player:call("addHunterWireWildNum",1)
    return Success
end

local function CCSetInvisible(shouldInvis)
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local invis = not shouldInvis
    print(invis)
    player._isDrawPlayer = invis
    return Success
end

--Blastblight
local function CCSetBlast()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._BombDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._BombDurationTimer = 20
    return Success
end
--end of Blastblight

--Hellfire
local function CCSetHellfire()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._OniBombDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._OniBombDurationTimer = 300
    return Success
end
--END OF Hellfire

--START of Fireblight
local function CCSetFire()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._FireLDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._FireLDurationTimer = 3600
    return Success
end
--END of Fireblight
--START of Waterblight
local function CCSetWater()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._WaterLDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._WaterLDurationTimer = 3600
    return Success
end
--END of Waterblight
--START of Iceblight
local function CCSetIce()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._IceLDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._IceLDurationTimer = 3600
    return Success
end
--END of Iceblight
--START of Thunderblight
local function CCSetThunder()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._ThunderLDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._ThunderLDurationTimer = 3600
    return Success
end
--END of Thunderblight
--START of Dragonblight
local function CCSetDragon()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._DragonLDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._DragonLDurationTimer = 3600
    return Success
end
--END of Dragonblight
--START of Bloodblight
local function CCSetBlood()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._MysteryDebuffTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._MysteryDebuffTimer = 3600
    return Success
end
--END of Bloodblight
local function CCSetStench()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local current = player._StinkDurationTimer
    print(current)
    if current ~= 0.0 then
        return Retry
    end
    player._StinkDurationTimer = 5000
    return Success
end
--END of Bloodblight
-- HP to 10 START --
--------------------
local function CCSetHPOne()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local playerData = player._refPlayerData
    if not playerData then
        return Failure
    end
    playerData:call("set__vital",1.0)
    playerData._r_Vital = 1.0
    return Success
end
-- HP to 10 END --
--------------------
local function CCStaminaDrain()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local playerData = player:call("get_PlayerData")
    if not playerData then
        return Failure
    end
    local maxStaminaOldValue = playerData:get_field("_staminaMax")
    if not maxStaminaOldValue then
      return Failure
    end
    playerData:set_field("_staminaMax", 0)
    return Success
end
-- END OF STAM DRAIN
--Atk Nerf 50%
local function CCAtkDown()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local playerData = player:call("get_PlayerData")
    if not playerData then
        return Failure
    end
    local currentAttack = playerData:get_field("_Attack")
    if not currentAttack then
      return Failure
    end
    local current = playerData:get_field("_AtkUpBuffSecondTimer")
    print(current)
    if current ~= 0.000 then
      return Retry
    end
    playerData:set_field("_AtkUpBuffSecond", currentAttack/2 - currentAttack) -- 50% of current
    playerData:set_field("_AtkUpBuffSecondTimer", 3600) --One Minute
    return Success
end

local function CCDefDown()
   local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local playerData = player:call("get_PlayerData")
    if not playerData then
        return Failure
    end
    local currentDefence = playerData:get_field("_Defence")
    if not currentDefence then
      return Failure
    end
    local current = playerData:get_field("_DefUpBuffSecondTimer")
    print(current)
    if current ~= 0.000 then
      return Retry
    end
    playerData:set_field("_DefUpBuffSecond", currentDefence/2 - currentDefence) -- 50% of current
    playerData:set_field("_DefUpBuffSecondTimer", 3600) --One Minute
    return Success
  end

--
--
--
--WORK IN PROGRESS
--
--
--
local function CCChainsawMassacre()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    local playerData = player:call("get_PlayerData")
    if not playerData then
        return Failure
    end
    local currentSawNumber = playerData:get_field("_ChainsawHitNumMax")
    if not currentSawNumber then
      return Failure
    end
    playerData:set_field("_ChainsawHitNumMax", 25) -- 50% of current
    return Success
end

local function CCNSWView(turnOn)
    local scnman = sdk.get_native_singleton("via.SceneManager")
    local scnmantyp = sdk.find_type_definition("via.SceneManager")
    local scnview = sdk.call_native_func(scnman,scnmantyp,"get_MainView")

    if scnview ~= nil then
        local dispType = scnview:call("get_DisplayType")
        if DisplayType == nil then
            DisplayType = dispType
        end
        if turnOn == true then
            if DisplayType ~= dispType then
                return Retry
            end
            dispType = math.floor(math.random(14,16))
            scnview:call("set_DisplayType",dispType) --floored just in case
            CurrentDisplay = dispType
        else
            scnview:call("set_DisplayType",DisplayType)
            CurrentDisplay = DisplayType
        end
        return Success
    end
end

function CCCodeToName(code)
    if code == "inflict_frenzy" then
        return "Inflict Frenzy Virus"
    end
    if code == "inflict_bleed" then
        return "Inflict Bleed"
    end
    if code == "attackdown" then
        return "Attack down -50%"
    end
    if code == "defensedown" then
        return "Defense Down -50%"
    end
    if code == "inflict_poison" then
        return "Inflict Poison"
    end
    if code == "inflict_noxiouspoison" then
        return "Inflict Noxious Poison"
    end
    if code == "inflict_deadlypoison" then
        return "Inflict Deadly Poison"
    end
    if code == "inflict_bubble_m" then
        return "Inflict Mild Bubbleblight"
    end
    if code == "inflict_bubble_l" then
        return "Inflict Severe Bubbleblight"
    end
    if code == "hpone" then
        return "Reduce HP to 1"
    end
    if code == "chainsawinfini" then
        return "Chainsaw Massacre"
    end
    if code == "staminadrain" then
        return "Drain Stamina"
    end
    if code == "inflict_blast" then
        return "KABOOM"
    end
    if code == "inflict_hellfire" then
        return "Inflict Hellfire"
    end
    if code == "inflict_fireblight" then
        return "Inflict Fireblight"
    end
    if code == "inflict_waterblight" then
        return "Inflict Waterblight"
    end
    if code == "inflict_iceblight" then
        return "Inflict Iceblight"
    end
    if code == "inflict_thunderblight" then
        return "Inflict Iceblight"
    end
    if code == "inflict_dragonblight" then
        return "Inflict Dragonblight"
    end
    if code == "inflict_stench" then
        return "Inflict Stench"
    end
    if code == "inflict_bloodblight" then
        return "Inflict Bloodblight"
    end
    if code == "addwirebug" then
        return "Add Wirebug"
    end
    if code == "nswview" then
        return "Switch Curse"
    end
    if code == "invisp1" then
        return "Hunter Invisible (30 Seconds)"
    end
    return "Unknown Effect"
end

function CCRunRequest()
    print(CCRequestString)
    local request = CCRequest:from_json(CCRequestString)
    --print(request)
    if request == nil then
        return ""
    end
    --go ahead and create a response and we can just fill it in as we go
    local response = CCResponse:new()
    --print(response)
    --now we handle the code
    response.id = request.id
    local code = request.code
    if code == "inflict_frenzy" then
        local res = CCSetVirus()
        print(res)
        response.status = res
    end
    if code == "inflict_bleed" then
        local res = CCSetBleed()
        response.status = res
    end
    if code == "inflict_poison" then
        local res = CCSetPoison()
        response.status = res
    end
    if code == "inflict_noxiouspoison" then
        local res = CCSetNoxious()
        response.status = res
    end
    if code == "inflict_deadlypoison" then
        local res = CCSetDeadly()
        response.status = res
    end
    if code == "inflict_bubble_m" then
        local res = CCSetBubbleM()
        response.status = res
    end
    if code == "inflict_bubble_l" then
        local res = CCSetBubbleL()
        response.status = res
    end
    if code == "inflict_blast" then
        local res = CCSetBlast()
        response.status = res
      end
    if code == "inflict_hellfire" then
          local res = CCSetHellfire()
          response.status = res
      end
      if code == "inflict_stench" then
            local res = CCSetStench()
            response.status = res
        end
    if code == "inflict_fireblight" then
            local res = CCSetFire()
            response.status = res
    end
    if code == "inflict_waterblight" then
            local res = CCSetWater()
            response.status = res
    end
    if code == "inflict_iceblight" then
            local res = CCSetIce()
            response.status = res
    end
    if code == "inflict_thunderblight" then
            local res = CCSetThunder()
            response.status = res
    end
    if code == "inflict_dragonblight" then
            local res = CCSetDragon()
            response.status = res
    end
    if code == "inflict_bloodblight" then
            local res = CCSetBlood()
            response.status = res
    end
    if code == "hpone" then
        local res = CCSetHPOne()
        response.status = res
    end
    if code == "staminadrain" then
        local res = CCStaminaDrain()
        response.status = res
        end
    if code == "attackdown" then
            local res = CCAtkDown()
            response.status = res
        end
    if code == "defensedown" then
            local res = CCDefDown()
            response.status = res
        end
        if code == "chainsawinfini" then
                local res = CCChainsawMassacre()
                response.status = res
            end
    if code == "addwirebug" then
        local res = CCAddWirebug()
        response.status = res
    end
    if code == "nswview" then
        local res = CCNSWView(true)
        response.status = res
        SwitchViewTimer = 1800 --game uses delta time which is seconds between frames
        response.timeRemaining = (SwitchViewTimer/60) * 1000
    end
    if code == "invisp1" then
        local res = CCSetInvisible(true)
        response.status = res
        InvisibleTimer = 1800
        response.timeRemaining = (InvisibleTimer/60) * 1000
        IsInvis = true
    end
    --print(response.id)
    print(response.status)
    if response.status == Success then
        --now we create a string to send the player
        SendMessage(string.format("<COL RED>%s</COL> has sent <PL>: %s",request.viewer,CCCodeToName(code)))
    end
    restr = CCResponse:to_json(response)
    print(restr)
    return restr
end

local function CCTestEffect()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    player:setDie()
end

local function CCUseItem()
    local playman = sdk.get_managed_singleton("snow.player.PlayerManager")

    if not playman then
        --print("playman fail")
        return Failure
    end

    local player = playman:call("findMasterPlayer")
    --player = snow.player.PlayerBase
    if not player then
        --print("Player fail")
        return Failure
    end
    local typedef = player:get_type_definition()
    local isQuest = typedef:is_a("snow.player.PlayerQuestBase")
    if not isQuest then
        return Retry
    end
    player:useItem(false)
end

math.randomseed(os.time())

local function UpdateTimers()
    local application = sdk.get_native_singleton("via.Application")

    if not application then
        return nil
    end
    local app_type = sdk.find_type_definition("via.Application")
    local deltaTime = sdk.call_native_func(application, app_type, "get_DeltaTime")


    if SwitchViewTimer > 0 then
        SwitchViewTimer = SwitchViewTimer - deltaTime
    end
    if InvisibleTimer > 0 then
        InvisibleTimer = InvisibleTimer - deltaTime
    end
end

re.on_pre_application_entry("UpdateBehavior", function()
    --main loop access, update timers in here
    UpdateTimers()
    if SwitchViewTimer <= 0 then
        if CurrentDisplay ~= DisplayType then
            CCNSWView(false)
        end
    end
    if InvisibleTimer <= 0 then
        if IsInvis then
            CCSetInvisible(false)
            IsInvis = false
        end
    end
end)

re.on_draw_ui(function()
    -- Obtain the FigureManager singleton.
    if imgui.tree_node("Status Test") then
        -- Get the current figure/model being displayed.
        imgui.push_id(0)
        if imgui.button("Test Effect") then
            CCTestEffect()
        end
        if imgui.button("Frenzy Virus") then
            CCSetVirus()
        end
        if imgui.button("Bleed") then
            CCSetBleed()
        end
        if imgui.button("Hp 0") then
            CCSetHPOne()
        end
        if imgui.button("Min Sharpness") then
            CCMinSharpness()
        end
        if imgui.button("Add Wirebug") then
            CCAddWirebug()
        end
        if imgui.button("NSW View") then
            CCNSWView(true)
            SwitchViewTimer = 1800.0
        end
        if imgui.button("Stamina Test") then
            CCStaminaDrain()
        end
        if imgui.button("Set Die") then
            CCTestEffect(true)
        end
        if imgui.button("UseItem") then
            CCUseItem()
        end
        if imgui.button("SetInvis") then
            CCSetInvisible(true)
            InvisibleTimer = 1800.0
            IsInvis = true
        end
    end
end)
