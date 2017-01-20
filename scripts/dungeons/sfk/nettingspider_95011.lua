-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95011

local spells = {}
local timers = {}

spells["net"] = 71010
spells["netroot"] = 12252

timers["net"] = 10000
timers["secondnet"] = 4500

local function net(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(100)

  local playerIndex = math.random(1, #players)
  local target = players[playerIndex]

  if target:HasAura(spells["net"]) then 
    return
  end

  target:CastSpell(target, spells["net"], true)
  creature:CastSpell(target, spells["netroot"], true)
end

local function firstnet(eventID, delay, pCall, creature)
  net(nil, nil, nil, creature)
  creature:RegisterEvent(net, timers["secondnet"], 0)
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(firstnet, timers["net"], 1)
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