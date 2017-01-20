local npcEntry = 96005
local spells = {}
local timers = {}

spells["heroicstrike"] = 93011
timers["heroicstrike"] = 3000

local function heroicstrike(eventID, delay, pCall, cr)
  cr:CastSpellRAI(cr:GetVictim(), spells["heroicstrike"], true)
end

local function OnEnterCombat(event, cr, target)
  cr:RegisterEvent(heroicstrike, timers["heroicstrike"], 0)
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