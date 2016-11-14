-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95017

local spells = {}
local timers = {}

spells["spellshield"] = 33054
spells["lightningshield"] = 49281
spells["frostbolt"] = 90028
spells["frostnova"] = 90029

timers["spellshield"] = 2000
timers["lightningshield"] = 2000
timers["frostbolt"] = 5000
timers["frostnova"] = 14000

local function removeauras(creature)
  local skeletalwarriors = creature:GetCreaturesInRange(5, 95015)

  for _, warrior in pairs(skeletalwarriors) do 
    warrior:RemoveAura(spells["spellshield"])
    warrior:RemoveAura(spells["lightningshield"])
  end
end

local function spellshield(eventID, delay, pCall, creature)
  local skeletalwarriors = creature:GetCreaturesInRange(5, 95015)

  for _, warrior in pairs(skeletalwarriors) do
    if not warrior:HasAura(spells["spellshield"]) then 
      warrior:CastSpell(warrior, spells["spellshield"], true)
    end 
  end  

end

local function lightningshield(eventID, delay, pCall, creature)
  local skeletalwarriors = creature:GetCreaturesInRange(5, 95015)

  for _, warrior in pairs(skeletalwarriors) do 
    if not warrior:HasAura(spells["lightningshield"]) then 
      warrior:CastSpell(warrior, spells["lightningshield"], true)
    end
  end
end

local function frostbolt(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["frostbolt"])
end

local function frostnova(eventID, delay, pCall, creature)
  creature:CastSpell(creature, spells["frostnova"])
end

local function OnSpawn(event, creature)
  creature:RegisterEvent(spellshield, 0, 1)
  creature:RegisterEvent(lightningshield, 0, 1)

  creature:RegisterEvent(spellshield, timers["spellshield"], 0)
  creature:RegisterEvent(lightningshield, timers["lightningshield"], 0)
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(frostbolt, 0, 1)
  creature:RegisterEvent(frostnova, 3500, 1)

  creature:RegisterEvent(frostbolt, timers["frostbolt"], 0)
  creature:RegisterEvent(frostnova, timers["frostnova"], 0)
end

local function OnLeaveCombat(event, creature)
  removeauras(creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  removeauras(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)