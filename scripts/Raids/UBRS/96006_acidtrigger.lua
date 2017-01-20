local npcEntry = 96006
local spells = {}
local timers = {}

spells["acid"] = 93006

local function despawnSelf(_, _, _, cr)
  cr:DespawnOrUnsummon(1)
end

local function spawnAcid(eventID, delay, pCall, cr)
  cr:CastSpell(cr, spells["acid"], true)
end

local function OnSpawn(event, cr)
  cr:RegisterEvent(spawnAcid, 0, 1)
  cr:RegisterEvent(despawnSelf, 114000, 1)
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