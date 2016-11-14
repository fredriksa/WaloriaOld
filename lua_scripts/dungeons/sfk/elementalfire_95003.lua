-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local spells = {}
local timers = {}
local private = {}

spells["immolationvisual"] = 54690
spells["burningaoe"] = 90007
spells["firebeam"] = 45576
spells["blastwave"] = 11113

timers["blastwave"] = 3100
timers["firebeam"] = 3000
timers["firebeamtick"] = 700

local firebeamTargetGUID = nil

local function blastWave(eventID, delay, pCall, creature)
  --creature:CastSpell(creature, spells["blastwave"], true)
end

local function firebeamtick(eventID, delay, pCall, creature)
  local player = GetPlayerByGUID(firebeamTargetGUID)
  creature:CastSpell(player, spells["burningaoe"], true)
end

local function firebeam(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(50)
  local playerIndex = math.random(1, #players)

  local lowPlayerGUID = players[playerIndex]:GetGUIDLow()
  firebeamTargetGUID = GetPlayerGUID(lowPlayerGUID)

  creature:CastSpell(players[playerIndex], spells["immolationvisual"], true)
  creature:CastSpell(players[playerIndex], spells["firebeam"], true)

  local nFireBeamTicks = math.floor(timers["firebeam"]/timers["firebeamtick"])
  creature:RegisterEvent(firebeamtick, timers["firebeamtick"], nFireBeamTicks)
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(blastWave, timers["blastwave"], 0)
  creature:RegisterEvent(firebeam, timers["firebeam"], 0)
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(95003, 1, OnEnterCombat)
RegisterCreatureEvent(95003, 2, OnLeaveCombat)
RegisterCreatureEvent(95003, 4, OnDied)