-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local spells = {}
local timers = {}
local private = {}

spells["frostbolt"] = 90006
timers["frostboltaoe"] = 2000

local function frostboltaoe(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(50)

  for _, player in pairs(players) do
    creature:CastSpell(player, spells["frostbolt"], true)
  end
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(frostboltaoe, timers["frostboltaoe"], 0)
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(95004, 1, OnEnterCombat)
RegisterCreatureEvent(95004, 2, OnLeaveCombat)
RegisterCreatureEvent(95004, 4, OnDied)