local npcEntry = 96010
local spells = {}
local timers = {}

spells["fire"] = 93023
spells["flameshield"] = 93025

local function addAuraToPlayer(_, _, _, cr)
  local players = cr:GetPlayersInRange(1)
  if not players then return end

  local target = players[1]
  if not target then return end

  target:CastSpell(target, spells["flameshield"], true)
  cr:DespawnOrUnsummon(1)
end

local function despawnSelf(_, _, _, cr)
  cr:DespawnOrUnsummon(1)
end

local function fire(eventID, delay, pCall, cr)
  cr:CastSpellRAI(cr, spells["fire"], true)
end

local function OnSpawn(event, cr)
  cr:RegisterEvent(fire, 0, 1)
  cr:RegisterEvent(despawnSelf, 12000, 1)
  cr:RegisterEvent(addAuraToPlayer, 100, 0)
end

local function OnLeaveCombat(event, cr)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  cr:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)