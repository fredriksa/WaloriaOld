-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95013

local spells = {}
local timers = {}

spells["smash"] = 14102

timers["smash"] = 4000

local function smash(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(250)

  for _, player in pairs(players) do 
    creature:CastSpell(player, spells["smash"], true)
  end
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(smash, timers["smash"], 0)
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