-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95012

local spells = {}
local timers = {}

spells["sleep"] = 41396

timers["sleep"] = 5000

local function sleep(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(100)

  local playerIndex = math.random(1, #players)
  local target = players[playerIndex]

  creature:CastSpell(target, spells["sleep"], true)
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(sleep, timers["sleep"], 0)
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)