-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScriptslocal npcEntry = 95016

local spells = {}
local timers = {}

spells["ripflesh"] = 90030
spells["gutrip"] = 90031
spells["infuriated"] = 32886

timers["ripflesh"] = 5000
timers["gutrip"] = 7500
timers["infuriated"] = 12000

local function ripflesh(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["ripflesh"], true)
end

local function gutrip(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["gutrip"], true)
end

local function infuriated(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["infuriated"], true)
end

local function OnEnterCombat(event, creature, target)
  -- First couple of spells
  creature:RegisterEvent(ripflesh, 0, 1)

  if math.random(1, 2) == 1 then 
    creature:RegisterEvent(infuriated, 0, 1)
  end

  -- Register spells
  creature:RegisterEvent(ripflesh, timers["ripflesh"], 0)
  creature:RegisterEvent(gutrip, timers["gutrip"], 0)
  creature:RegisterEvent(infuriated, timers["infuriated"], 0)
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