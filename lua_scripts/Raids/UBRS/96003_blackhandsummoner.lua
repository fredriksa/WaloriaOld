local npcEntry = 96003
local spells = {}
local timers = {}

spells["fear"] = 31970
spells["summoneffect"] = 72711
spells["summondragon"] = 93000
spells["shadowboltvolley"] = 93009

timers["shadowboltvolley"] = 4000
timers["fear"] = 10000

local function shadowboltvolley(_, _, _, cr)
  cr:CastSpellRAI(cr:GetVictim(), spells["shadowboltvolley"], true)
end

local function summondragon(_, _, _, cr)
  cr:CastSpell(cr, spells["summondragon"], true)
end

local function summoneffect(eventID, delay, pCall, cr)
  if not cr:IsInCombat() then 
    cr:CastSpell(cr, spells["summoneffect"], true)
  end
end

local function fear(eventID, delay, pCall, cr)
  cr:CastSpellRAI(cr:GetVictim(), spells["fear"], true)
end

local function OnEnterCombat(event, cr, target)
  if math.random(1, 2) == 1 then 
    cr:RegisterEvent(fear, 0, 1)
  end

  cr:RemoveAura(spells["summoneffect"])
  cr:SetData("dragons", {})
  cr:RegisterEvent(fear, timers["fear"], 0)
  cr:RegisterEvent(summondragon, 0, 1)
  cr:RegisterEvent(shadowboltvolley, timers["shadowboltvolley"], 0)
end

local function OnLeaveCombat(event, cr)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  cr:RemoveEvents()
end

local function OnSpawn(event, cr)
  cr:RegisterEvent(summoneffect, 5000, 0)
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)