-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local creatureEntry = 95007

local spells = {}
local timers = {}

spells["shadowbolt"] = 90013
spells["shadowboltaoe"] = 90014
spells["curseofagony"] = 90015
spells["fear"] = 38154

timers["shadowbolt"] = 3300
timers["curseofagony"] = 24000

local function shadowbolt(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["shadowbolt"], true)
end

local function curseofagony(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(60)

  for _, player in pairs(players) do 
    creature:CastSpell(player, spells["curseofagony"], true)
  end
end

local function fearaoe(creature)
  local players = creature:GetPlayersInRange(5)

  for _, player in pairs(players) do 
    creature:CastSpell(player, spells["fear"], true)
  end
end

local function shadowboltaoe(creature)
  creature:CastSpell(creature, spells["shadowboltaoe"], true)
end

local function OnEnterCombat(event, creature, target)
  curseofagony(nil, nil, nil, creature)
  creature:RegisterEvent(shadowbolt, timers["shadowbolt"], 0)
  creature:RegisterEvent(curseofagony, timers["curseofagony"], 0)
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  fearaoe(creature)
  shadowboltaoe(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(creatureEntry, 1, OnEnterCombat)
RegisterCreatureEvent(creatureEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(creatureEntry, 4, OnDied)