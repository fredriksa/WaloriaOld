-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local spells = {}
local timers = {}
local private = {}

spells["stun"] = 46441
spells["earthshock"] = 90005

timers["stunaoe"] = 9000
timers["earthshock"] = 3200

local function stunaoe(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(50)

  for _, player in pairs(players) do
    player:CastSpell(player, spells["stun"], true)
  end
end

local function castEarthshock(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["earthshock"])
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(stunaoe, timers["stunaoe"], 0)
  creature:RegisterEvent(castEarthshock, timers["earthshock"], 0)
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(95005, 1, OnEnterCombat)
RegisterCreatureEvent(95005, 2, OnLeaveCombat)
RegisterCreatureEvent(95005, 4, OnDied)