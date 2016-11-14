-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local creatureEntry = 95006

local spells = {}
local timers = {}

spells["shadowstep"] = 36563
spells["mightykick"] = 69021 
spells["backstab"] = 90012

timers["jumpattack"] = 4000

local function jumpattack(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(40)
  local playerIndex = math.random(1, #players)
  local target = players[playerIndex]

  creature:CastSpell(target, spells["shadowstep"], true)
  creature:CastSpell(target, spells["mightykick"], true)
  creature:CastSpell(target, spells["backstab"], true)
  --creature:AddThreat(target, 999.0, 1) Typo in lua bridge, will be solved in future
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(jumpattack, timers["jumpattack"], 0)
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(creatureEntry, 1, OnEnterCombat)
RegisterCreatureEvent(creatureEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(creatureEntry, 4, OnDied)