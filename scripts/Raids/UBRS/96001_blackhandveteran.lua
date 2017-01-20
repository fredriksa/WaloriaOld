local npcEntry = 96001
local spells = {}
local timers = {}
local creatures = {}

spells["shadowstep"] = 45273
spells["ambush"] = 39669
spells["taunt"] = 93026
spells["poison"] = 72329
spells["buffaura"] = 93004

timers["stepcombo"] = 8000
timers["checkAuraWeaver"] = 1500

creatures["weaver"] = 96002

local function checkAuraWeaver(eventID, delay, pCall, cr)
  local weavers = cr:GetCreaturesInRange(15, creatures["weaver"], 0, 1)

  if not weavers or #weavers == 0 then 
    cr:RemoveAura(spells["buffaura"])
  else
    cr:AddAura(spells["buffaura"], cr)
  end
end

local function stepcombo(eventID, delay, pCall, cr)
  local targets = cr:GetAITargets()
  local target = nil

  if #targets == 0 then 
    return false
  elseif #targets == 1 then 
    target = targets[1]
  else
    target = targets[math.random(1, #targets)]
  end

  target:CastSpell(cr, spells["taunt"], true) --Doesn't work if player is at spell limit
  cr:CastSpellRAI(target, spells["shadowstep"], true)
  cr:CastSpellRAI(target, spells["ambush"], true)
  cr:CastSpellRAI(target, spells["poison"])
end

local function OnEnterCombat(event, cr, target)
  cr:RegisterEvent(checkAuraWeaver, 0, 1)
  cr:RegisterEvent(checkAuraWeaver, timers["checkAuraWeaver"], 0)
  cr:RegisterEvent(stepcombo, 0, 1)
  cr:RegisterEvent(stepcombo, timers["stepcombo"], 0)
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