local npcEntry = 96008
local spells = {}
local timers = {}

spells["shield"] = 93018

local function despawnSelf(_, _, _, cr)
  cr:DespawnOrUnsummon(1)
end

local function shield(eventID, delay, pCall, cr)
  cr:CastSpellRAI(cr, spells["shield"], true)
end

local function OnSpawn(event, cr)
  cr:RegisterEvent(shield, 0, 1)
  cr:RegisterEvent(despawnSelf, 114000, 1)
end

local function OnEnterCombat(event, cr, target)

end

local function OnLeaveCombat(event, cr)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  cr:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)