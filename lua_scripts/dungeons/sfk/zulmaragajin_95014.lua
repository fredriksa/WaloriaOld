-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local spells = {}
local timers = {}
local pets = {}
local summonedPets = {}
local Zulmara = {}

spells["arcaneshot"] = 90018
spells["explosiveshot"] = 90019
spells["explosiveknockback"] = 69021
spells["frosttrapaoe"] = 90020
spells["volley"] = 90021
spells["enlarge"] = 8212
spells["cleave"] = 90022
spells["eclipsevisual"] = 65632

spells["immolationtrap"] = 90023
spells["icetrap"] = 90024

timers["arcaneshot"] = 2900
timers["explosiveshot"] = 14400
timers["frosttrapaoe"] = 30000
timers["volley"] = 5500
timers["spawntrap"] = 3300
timers["spawnPets"] = 7000
timers["cleave"] = 1100

pets["basilisk"] = 95010
pets["spider"] = 95011
pets["scorpid"] = 95012
pets["monkey"] = 95013

local function reset(creature)
  creature:SetData("one", false)
  creature:SetData("two", false)
  creature:SetData("three", false)
end

-- Phases

function Zulmara.enterCombat(creature)
  creature:SendUnitYell("", 0)
end

function Zulmara.phaseOne(creature) 
  creature:SendUnitYell("Don't be shy.", 0)
  Zulmara.registerBaseRotation(creature)
  creature:RegisterEvent(Zulmara.frostTrapAoe, timers["frosttrapaoe"], 0)
  creature:RegisterEvent(Zulmara.volley, timers["volley"], 0)
  creature:RegisterEvent(Zulmara.spawnTraps, timers["spawntrap"], 0)
end

-- Summon pets phase
function Zulmara.phaseTwo(creature)
  creature:SendUnitYell("Stay away from the Voodoo.", 0)
  creature:RegisterEvent(Zulmara.spawnPets, 0, 1)
  creature:RegisterEvent(Zulmara.spawnPets, timers["spawnPets"], 0)
  Zulmara.registerBaseRotation(creature)
end

function Zulmara.phaseThree(creature)
  creature:SetRooted(false)
  creature:SendUnitYell("Be cool mon!", 0)
  creature:RegisterEvent(Zulmara.enlarge, 0, 1) 
  Zulmara.registerBaseRotation(creature)
  creature:RegisterEvent(Zulmara.volley, timers["volley"], 0)
  creature:RegisterEvent(Zulmara.volley, timers["volley"], 0)
  creature:RegisterEvent(Zulmara.castArcaneShot, timers["arcaneshot"], 0)
  creature:RegisterEvent(Zulmara.cleave, timers["cleave"], 0)
  Zulmara.registerBaseRotation(creature)
end

function Zulmara.registerBaseRotation(creature)
  creature:RegisterEvent(Zulmara.explosiveShot, timers["explosiveshot"], 0)
  creature:RegisterEvent(Zulmara.castArcaneShot, timers["arcaneshot"], 0)
end

function Zulmara.spawnPets(eventID, delay, pCall, creature)
  -- Spawns 1 to 3 pets
  for i=1, math.random(1,2), 1 do 
    local petIndex = math.random(1, 4)
    local petEntry = 0

    if petIndex == 1 then
      petEntry = pets["basilisk"]
    elseif petIndex == 2 then
      petEntry = pets["spider"]
    elseif petIndex == 3 then
      petEntry = pets["scorpid"]
    elseif petIndex == 4 then
      petEntry = pets["monkey"]
    end

    local x = creature:GetX() + math.random(-5, 5) 
    local y = creature:GetY() + math.random(-5, 5) 
    local z = creature:GetZ()
    local o = creature:GetO()

    pet = creature:SpawnCreature(petEntry, x, y, z, o, 2, 300000)
    pet:AttackStart(creature:GetVictim())
    table.insert(summonedPets, pet:GetGUIDLow())
  end
end

function Zulmara.despawnPets(creature)
  local creatures = creature:GetCreaturesInRange(100)

  for _, pLowGUID in pairs(summonedPets) do 
    for __, creature in pairs(creatures) do 

      if pLowGUID == creature:GetGUIDLow() then 
        creature:DespawnOrUnsummon(0)
      end

    end
  end
end

function Zulmara.spawnTraps(eventID, delay, pCall, creature)
  local trapIndex = math.random(1, 2)
  local spellEntry = 0

  if trapIndex == 1 then 
    spellEntry = spells["immolationtrap"]
  elseif trapIndex == 2 then 
    spellEntry = spells["icetrap"]
  end

  creature:CastSpell(creature, spellEntry, true)
end

function Zulmara.playerInList(playerList, player)
  for _, p in pairs(playerList) do 
    if p:GetGUIDLow() == player:GetGUIDLow() then
      return true
    end
  end

  return false
end

function Zulmara.cleave(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["cleave"], true)
end

function Zulmara.enlarge(eventID, delay, pCall, creature)
  creature:CastSpell(creature, spells["enlarge"], true)
  creature:CastSpell(creature, spells["eclipsevisual"], true)
end

function Zulmara.volley(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(100)
  local playersNear = creature:GetPlayersInRange(0.3)

  -- 25 tries before giving up finding player
  for i=1, 25, 1 do 
    local playerIndex = math.random(1, #players)
    local playerTarget = players[playerIndex]

    if not Zulmara.playerInList(playersNear, playerTarget) then 
      creature:CastSpell(playerTarget, spells["volley"], true)
    end
  end

end

function Zulmara.frostTrapAoe(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(100)
  local playerIndex = math.random(1, #players)
  local playerTarget = players[playerIndex]

  creature:CastSpell(playerTarget, spells["frosttrapaoe"], true)
end

function Zulmara.explosiveShot(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["explosiveshot"], true)
  creature:CastSpell(creature:GetVictim(), spells["explosiveknockback"], true)
end

function Zulmara.castArcaneShot(eventID, delay, pCall, creature)
  local playersNear = creature:GetPlayersInRange(2)
  local currentTarget = creature:GetVictim()

  if Zulmara.playerInList(playersNear, currentTarget) then 
    -- If the NPC's current target is too close find a new target to cast the spell at
    local players = creature:GetPlayersInRange(100) 

    -- 25 tries before giving up finding player
    for i=1, 25, 1 do 
      local playerIndex = math.random(1, #players)
      local playerTarget = players[playerIndex]

      -- Shoots two arcane shots at random targets if tank is within tanking range
      if not Zulmara.playerInList(playersNear, playerTarget) then 
        creature:CastSpell(playerTarget, spells["arcaneshot"], true)
        local playerIndex = math.random(1, #players)
        local playerTarget = players[playerIndex]
        creature:CastSpell(playerTarget, spells["arcaneshot"], true)
        return
      end
    end
  else
    creature:CastSpell(currentTarget, spells["arcaneshot"], true)
  end
end

local function OnSpawn(event, creature)
  creature:SetData("one", false)
  creature:SetData("two", false)
  creature:SetData("three", false)
end

local function OnEnterCombat(event, creature, target)
  creature:SetRooted(true)
  Zulmara.registerBaseRotation(creature)
  Zulmara.enterCombat(creature)
end

local function OnDamageTaken(event, creature, attacker, damage)
  local cHealthPct = creature:GetHealthPct()

  if cHealthPct > 60 and cHealthPct < 90 and not creature:GetData("one") then
    creature:RemoveEvents()
    Zulmara.phaseOne(creature)
  
    creature:SetData("one", true)
  end

  if cHealthPct > 20 and cHealthPct < 60 and not creature:GetData("two") then
    creature:RemoveEvents()
    Zulmara.phaseTwo(creature)

    creature:SetData("two", true)
  end

  if cHealthPct < 20 and not creature:GetData("three") then 
    creature:RemoveEvents()
    Zulmara.phaseThree(creature)

    creature:SetData("three", true)
  end

  if cHealthPct < 0 then 
    creature:RemoveEvents()
  end
end

function OnLeaveCombat(event, creature)
  Zulmara.despawnPets(creature)
  reset(creature)
  creature:SetRooted(false)
  creature:RemoveEvents()
end

function OnDied(event, creature, killer)
  Zulmara.despawnPets(creature)
  creature:SendUnitYell("I failed my call..", 0)
  reset(creature)
  creature:SetRooted(false)
  creature:RemoveEvents()
end

RegisterCreatureEvent(95014, 1, OnEnterCombat)
RegisterCreatureEvent(95014, 9, OnDamageTaken)
RegisterCreatureEvent(95014, 4, OnDied)
RegisterCreatureEvent(95014, 5, OnSpawn)
RegisterCreatureEvent(95014, 2, OnLeaveCombat)