-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 100006

local spells = {}
local timers = {}
local creatures = {}

spells["greencatmarker"] = 150007
spells["infernalimpactbasevisual"] = 150008
spells["felimmolation"] = 150009
spells["flametrail"] = 150010

timers["infernalimpactbasevisual"] = 6000
timers["aoePlayerDamage"] = 1000

creatures["flame"] = 100008
creatures["netharel"] = 100005

local function aoePlayerDamage(_, _, _, creature)
  local players = creature:GetPlayersInRange(3) 

  for _, player in pairs(players) do 
    player:CastSpell(player, spells["felimmolation"], true)
  end

  creature:CastSpell(creature, spells["flametrail"], true)
end

local function infernalImpact(_, _, _, creature)
  creature:CastSpell(creature, spells["infernalimpactbasevisual"], true)
  creature:RegisterEvent(aoePlayerDamage, timers["aoePlayerDamage"], 1)
  creature:RemoveAura(spells["greencatmarker"])
end

local function OnSpawn(event, creature)
  creature:SetData("flameGUIDs", {})
  creature:CastSpell(creature, spells["greencatmarker"], true)
  creature:RegisterEvent(infernalImpact, timers["infernalimpactbasevisual"], 1)
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)
RegisterCreatureEvent(npcEntry, 4, OnDied)