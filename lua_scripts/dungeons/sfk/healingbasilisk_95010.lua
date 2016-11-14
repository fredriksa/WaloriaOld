-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95010

local spells = {}
local timers = {}

spells["rejuvenation"] = 2091

timers["rejuvenation"] = 4000

local function rejuvenation(eventID, delay, pCall, creature)

  -- Gets zulmara the boss NPC
  local zulmara = creature:GetCreaturesInRange(250, 95014)

  creature:CastSpell(zulmara[1], spells["rejuvenation"], true)
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(rejuvenation, timers["rejuvenation"], 1)
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