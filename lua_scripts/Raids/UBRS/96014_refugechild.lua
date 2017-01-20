local npcEntry = 96014
local spells = {}

spells["cloud"] = 33070

local function OnSpawn(event, cr)
  cr:CastSpell(cr, spells["cloud"], true)
  cr:SetSpeed(0, 0.5)
  cr:SetSpeed(1, 0.5)
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