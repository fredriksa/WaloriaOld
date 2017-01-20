local npcEntry = 96000
local spells = {}
local timers = {}

spells["firebreath"] = 93002
timers["firebreath"] = 6000

local function breath(eventID, delay, pCall, cr)
  cr:CastSpellRAI(cr:GetVictim(), spells["firebreath"], true)
end

local function OnEnterCombat(event, cr, target)
  cr:RegisterEvent(breath, timers["firebreath"], 0)
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