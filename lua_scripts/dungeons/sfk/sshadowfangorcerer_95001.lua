-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local private = {}
local spells = {}
local cooldowns = {}
local elementals = {}

spells["fireball"] = 90003
spells["blastwave"] = 90004
spells["earthshock"] = 90005
spells["stun"] = 46441

cooldowns["fireball"] = 4200

elementals["fire"] = 95003
elementals["water"] = 95004
elementals["earth"] = 95005

private["nElementals"] = 3
private["maxelementals"] = 2

local function fireball(eventID, delay, pCall, creature)
  local victim = creature:GetVictim()

  if not victim then 
    return
  end

  creature:CastSpell(victim, spells["fireball"])
end

local function summonElemental(entry, creature)
  local x = creature:GetX()
  local y = creature:GetY()
  local z = creature:GetZ()
  local o = creature:GetO()

  local xModifier = math.random(-2, 2)
  local yModifier = math.random(-2, 2)

  elemental = creature:SpawnCreature(entry, x + xModifier, y + yModifier, z, o, 2, 300000)
  elemental:AttackStart(creature:GetVictim())

  local pos = 0
  if creature:GetData("elementals") == 1 then 
    pos = 1
  elseif creature:GetData("elementals") == 2 then
    pos = 2
  end

  local elementalGUIDs = creature:GetData("elementalGUIDs")
  table.insert(elementalGUIDs, elemental:GetGUIDLow())
  creature:SetData("elementalGUIDs", elementalGUIDs)

  creature:SetData("elementals", creature:GetData("elementals") + 1)
end

local function summonRandomElementals(eventID, delay, pCall, creature)
  if creature:GetData("elementals") + 1 > private["maxelementals"] then 
    return 
  end

  local elementalIndex = math.random(1, private["nElementals"])

  local elementalEntry = 0
  if elementalIndex == 1 then 
    elementalEntry = elementals["fire"]
  elseif elementalIndex == 2 then
    elementalEntry = elementals["water"]
  elseif elementalIndex == 3 then 
    elementalEntry = elementals["earth"]
  end

  summonElemental(elementalEntry, creature)
end

local function despawnElementals(creature)
  local creatures = creature:GetCreaturesInRange(100)

  for _, eLowGUID in pairs(creature:GetData("elementalGUIDs")) do
    for __, creature in pairs(creatures) do 

      if eLowGUID == creature:GetGUIDLow() then
        creature:DespawnOrUnsummon(0) -- Despawns our elemental
      end

    end
  end
end

local function reset(creature)
  despawnElementals(creature)
  creature:SetData("elementalGUIDs", {})
  creature:SetData("elementals", 0)
end

local function OnSpawn(event, creature)
  creature:SetData("elementalGUIDs", {})
  creature:SetData("elementals", 0)
end

local function OnEnterCombat(event, creature, target)
  creature:RegisterEvent(fireball, cooldowns["fireball"], 0)
  creature:RegisterEvent(summonRandomElementals, 100, 0)
end

local function OnLeaveCombat(event, creature)
  creature:RemoveEvents()
  reset(creature)
end

local function OnDied(event, creature, killer)
  creature:RemoveEvents()
  reset(creature)
end

RegisterCreatureEvent(95001, 1, OnEnterCombat)
RegisterCreatureEvent(95001, 2, OnLeaveCombat)
RegisterCreatureEvent(95001, 4, OnDied)
RegisterCreatureEvent(95001, 5, OnSpawn)
