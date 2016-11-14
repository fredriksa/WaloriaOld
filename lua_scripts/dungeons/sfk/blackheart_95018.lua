-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 95018

local spells = {}
local timers = {}
local creatures = {}

spells["pathofillidan"] = 50247
spells["meteorslash"] = 90034 --45150
spells["meteorstrikeground"] = 90035 --74648
spells["felflames"] = 90036--36248
spells["rainoffire"] = 38741
spells["firetrail"] = 40980
spells["huntersmark"] = 56303

timers["meteorslash"] = 3500
timers["felflames"] = 10500
timers["rainoffire"] = 2000

timers["meteorstrikeStart"] = 13000
-- meteorstrikeEnd = the amount of time a player has to move away
timers["meteorstrikeEnd"] = 4000

creatures["felimp"] = 95019
creatures["orb"] = 95020

local function reset(creature)
  creature:SetData("one", false)
  creature:SetData("two", false)
  creature:SetData("three", false)
  creature:SetData("impGUIDs", {})
  creature:SetData("orbGUIDs", {})
end

local function removeAuras(creature)
  creature:RemoveAura(spells["huntersmark"])
end

local function despawnImps(creature)
  local creatures = creature:GetCreaturesInRange(150)

  for _, iLowGUID in pairs(creature:GetData("impGUIDs")) do 
    for __, creature in pairs(creatures) do 

      if iLowGUID == creature:GetGUIDLow() then 
        creature:DespawnOrUnsummon(0)
      end

    end
  end
end

local function despawnOrbs(creature)
  local creatures = creature:GetCreaturesInRange(150)

  for _, oLowGUID in pairs(creature:GetData("orbGUIDs")) do 

    for __, creature in pairs(creatures) do 

      if oLowGUID == creature:GetGUIDLow() then
        creature:DespawnOrUnsummon(0)
      end

    end

  end

  local players = creature:GetPlayersInRange(500)

  for _, player in pairs(players) do 
    player:RemoveAura(61782)
  end
end

local function firetrail(eventID, delay, pCall, creature)
  creature:CastSpell(creature, spells["firetrail"], true)
end

local function meteorslash(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["meteorslash"], true)
end

local function felflames(eventID, delay, pCall, creature)
  creature:CastSpell(creature:GetVictim(), spells["felflames"])
end

local function meteorstrikeEnd(eventID, delay, pCall, creature)
  creature:CastSpell(creature, spells["meteorstrikeground"], true)
  removeAuras(creature)
end

local function meteorstrikeStart(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(45)
  local playerIndex = math.random(1, #players)
  local playerTarget = players[playerIndex]
  creature:CastSpell(creature, spells["huntersmark"])
  creature:RegisterEvent(meteorstrikeEnd, timers["meteorstrikeEnd"], 1)
end

local function spawnImps(eventID, delay, pCall, creature)
  -- Number of imps per position
  local impsPerSpawn = 6
  -- X, Y, Z
  local doorPos = {
    [1] = -122.181267,
    [2] = 2163.332275,
    [3] = 128.943756, 
  };

  local impPos = {
    [1] = {-118.698997, 2177, 130.580063, 1},
    [2] = {-170.579727, 2182.986816, 138.696991, 1},
    [3] = {-126.3, 2164.96, 138.697037, 1},
  };

  for i, coords in pairs(impPos) do 

    for i = 1, impsPerSpawn, 1 do 

      local x = coords[1] + math.random(-3, 3)
      local y = coords[2] + math.random(-3, 3)
      local z = coords[3] + math.random(-3, 3)

      local imp = creature:SpawnCreature(creatures["felimp"], x, y, z, coords[4], 2, 300000)
      imp:MoveTo(1, doorPos[1], doorPos[2], doorPos[3])

      local impGUIDs = creature:GetData("impGUIDs")
      table.insert(impGUIDs, imp:GetGUIDLow())
      creature:SetData("impGUIDs", impGUIDs)

    end

  end
end

local function spawnOrbs(eventID, delay, pCall, creature)
  local orbPos = {
    [1] = {-141, 2187.24, 128.95, 4.1},
    [2] = {-151.969604, 2158.25, 129.923126, 1.199834},
  };

  for i, coords in pairs (orbPos) do 
    local orb = creature:SpawnCreature(creatures["orb"], coords[1], coords[2], coords[3], coords[4], 2, 300000)
    local orbGUIDs = creature:GetData("orbGUIDs")
    table.insert(orbGUIDs, orb:GetGUIDLow())
    creature:SetData("orbGUIDs", orbGUIDs)
  end
end

local function rainoffireAoe(eventID, delay, pCall, creature)
  local players = creature:GetPlayersInRange(100)
  local playerIndex = math.random(1, #players)
  local player = players[playerIndex]

  local x = player:GetX()
  local y = player:GetY()
  local z = player:GetZ()

  creature:CastSpellAoF(x, y, z, spells["rainoffire"], true)
end

local function teleportDown(eventID, delay, pCall, creature)
  creature:NearTeleport(-145.923004, 2172.682129, 128, 2.7)
  creature:SetRooted(false)
end

local function teleportUp(eventID, delay, pCall, creature)
  creature:NearTeleport(-137, 2169.4, 136.577545, 2.79885)
  creature:RegisterEvent(spawnImps, 0, 1)
end

local function rainoffire(eventID, delay, pCall, creature)
  creature:CastSpell(creature, spells["rainoffire"], true)
end

local function registerBaseRotation(creature)
  creature:RegisterEvent(meteorslash, timers["meteorslash"], 0)
  creature:RegisterEvent(felflames, timers["felflames"] + timers["meteorslash"], 0)
end

local function impsGone(eventID, delay, pCall, creature)
  local creatures = creature:GetCreaturesInRange(100, creatures["felimp"])

  if #creatures <= 0 then
    creature:RemoveEvents()
    creature:RegisterEvent(teleportDown, 0, 1)
    registerBaseRotation(creature)
    despawnOrbs(creature) 
  end
end

local function phaseOne(creature)
  registerBaseRotation(creature)
  creature:RegisterEvent(meteorstrikeStart, 0, 1)
  creature:RegisterEvent(meteorstrikeStart, timers["meteorstrikeStart"], 0)
end

local function phaseTwo(creature)
  creature:RegisterEvent(rainoffire, 0, 1)
  creature:RegisterEvent(teleportUp, 1500, 1)
  creature:SetRooted(true)

  creature:RegisterEvent(spawnOrbs, 0, 1)
  creature:RegisterEvent(rainoffireAoe, timers["rainoffire"], 0)

  creature:RegisterEvent(impsGone, 2000, 0)
end

local function phaseThree(creature)
  local imps = creature:GetCreaturesInRange(100, creatures["felimp"])
  if imps then 
    creature:RegisterEvent(teleportDown, 0, 1)
    despawnImps(creature)
  end

  creature:SetRooted(false)
  despawnOrbs(creature)

  creature:RegisterEvent(rainoffire, 0, 1)

  creature:SendUnitYell("By fire I shall engulf you!", 0)

  creature:RegisterEvent(firetrail, 1100, 1)
  creature:RegisterEvent(meteorslash, timers["meteorslash"], 0)
end

local function OnSpawn(event, creature)
  creature:SetData("one", false)
  creature:SetData("two", false)
  creature:SetData("three", false)
  creature:SetData("impGUIDs", {})
  creature:SetData("orbGUIDs", {})
end

local function OnEnterCombat(event, creature, target)
  registerBaseRotation(creature)
  creature:SendUnitYell("Mortals..", 0)
  creature:CastSpell(creature, spells["pathofillidan"], true)
end

local function OnDamageTaken(event, creature, attacker, damage)
  local cHealthPct = creature:GetHealthPct()

  if cHealthPct > 60 and cHealthPct < 90 and not creature:GetData("one") then
    creature:RemoveEvents()
    phaseOne(creature)
  
    creature:SetData("one", true)
  end

  if cHealthPct > 30 and cHealthPct < 60 and not creature:GetData("two") then
    creature:RemoveEvents()
    phaseTwo(creature)

    creature:SetData("two", true)
  end

  if cHealthPct < 30 and not creature:GetData("three") then 
    removeAuras(creature)
    creature:RemoveEvents()
    phaseThree(creature)

    creature:SetData("three", true)
  end
end

local function OnLeaveCombat(event, creature)
  despawnImps(creature)
  despawnOrbs(creature)
  creature:RegisterEvent(teleportDown, 0, 1)
  reset(creature)
  creature:SetRooted(false)
  creature:RemoveEvents()
end

local function OnDied(event, creature, killer)
  despawnImps(creature)
  despawnOrbs(creature)
  reset(creature)
  creature:SetRooted(false)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)
RegisterCreatureEvent(npcEntry, 9, OnDamageTaken)

-- Fel flames 36248
-- AoE green 39429