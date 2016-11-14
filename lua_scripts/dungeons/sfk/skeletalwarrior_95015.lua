-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95015

local spells = {}
local timers = {}

spells["shockwave"] = 90025
spells["cleave"] = 90026

timers["shockwave"] = 14000
timers["cleave"] = 3000

local function shockwave(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["shockwave"], true)
end

local function cleave(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["cleave"], true)
end

local function OnEnterCombat(event, creature, target)
  -- First couple of spells
  creature:RegisterEvent(shockwave, 0, 1)

  -- Register spells
  creature:RegisterEvent(shockwave, timers["shockwave"], 0)
  creature:RegisterEvent(cleave, timers["cleave"], 0)
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