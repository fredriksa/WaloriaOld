-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 50010

local spells = {}
local timers = {}
local crs = {}

spells["frostbolt"] = 72501
spells["icebolt"] = 72501
spells["frostboltaoe"] = 72015
spells["blizzard"] = 70421
spells["crashingwave"] = 57652
spells["coneofcold"] = 42931
spells["frostqueensmark"] = 90045

timers["frostbolt"] = 5500
timers["coneofcold"] = 7500
timers["frostboltaoe"] = 4000
timers["crashingwave"] = 10000
timers["icespikeinterval"] = 1000

crs["icespike"] = 50021
crs["waterelemental"] = 50023

local function crashingwave(_, _, _, cr)
  if cr:HasUnitState(0x00008000) then -- Casting
    cr:RegisterEvent(crashingwave, 100, 1)
  else
    cr:CastSpell(cr:GetVictim(), spells["crashingwave"], true)
  end
end

local function despawnElementals(cr)
  local creatures = cr:GetCreaturesInRange()

   for _, iLowGUID in pairs(cr:GetData("waterelementals")) do 
    for __, creature in pairs(creatures) do 

      if iLowGUID == creature:GetGUIDLow() then 
        creature:DespawnOrUnsummon(0)
      end

    end
  end
end

local function spawnElementals(_, _, _, cr)
  local elementalPos = {
    [1] = {1786.842407, 1368.914673, 19.351530, 6.241806},
    [2] = {1807.465820, 1368.857788, 19.350573, 3.152579},
    [3] = {1807.530518, 1355.490479, 19.350601, 3.135127},
    [4] = {1786.890991, 1355.499146, 19.350878, 6.261449},
  };

  for i, coords in pairs (elementalPos) do 
    local elemental = cr:SpawnCreature(crs["waterelemental"], coords[1], coords[2], coords[3], coords[4], 2, 300000)
    elemental:AddUnitState(256)
    elemental:AddUnitState(5129)

    local waterelementals = cr:GetData("waterelementals")
    table.insert(waterelementals, elemental:GetGUIDLow())
    cr:SetData("waterelementals", waterelementals)
  end
end

local function despawnIceSpikes(cr)
  local crs = cr:GetCreaturesInRange(150)

  for _, iLowGUID in pairs(cr:GetData("icespikes")) do 
    for __, cr in pairs(crs) do 

      if iLowGUID == cr:GetGUIDLow() then 
        cr:DespawnOrUnsummon(0)
      end

    end
  end
end

local function spawnIceSpike(_, _, _, cr)
  local players = cr:GetPlayersInRange(1000)
  local target = nil 
  
  for _, player in ipairs(players) do 
    if player:HasAura(spells["frostqueensmark"]) then 
      target = player 
    end 
  end

  if not target:IsFalling() and not target:IsFlying() then
    local spike = cr:SpawnCreature(crs["icespike"], target:GetX(), target:GetY(), target:GetZ(), target:GetO(), 2, 300000)
    local icespikes = cr:GetData("icespikes")
    table.insert(icespikes, spike:GetGUIDLow())
    cr:SetData("icespikes", icespikes)
  end
end

local function removeFrostQueensMark(_, _, _, cr)
  cr:SetData("spawnedicespikes", 0)
  local players = cr:GetPlayersInRange(1000)

  for _, player in ipairs(players) do 
    if player:HasAura(spells["frostqueensmark"]) then 
      player:RemoveAura(spells["frostqueensmark"])
    end
  end

  cr:SendUnitYell("REMOVED MARK")
end

local function addFrostQueensMark(_, _, _, cr)
  local players = cr:GetPlayersInRange(100)
  local playerIndex = math.random(1, #players)
  local player = players[playerIndex]

  player:AddAura(spells["frostqueensmark"], player)
end

local function icespike(_, _, _, cr)
  local spawnedicespikes = cr:GetData("spawnedicespikes")
  spawnedicespikes = spawnedicespikes + 1

  if spawnedicespikes > 4 then 
    cr:RegisterEvent(removeFrostQueensMark, 0, 1)
    cr:RegisterEvent(addFrostQueensMark, 0, 1)
  end

  cr:RegisterEvent(spawnIceSpike, 0, 1)
  cr:SetData("spawnedicespikes", spawnedicespikes)
end

local function frostboltaoe(_, _, _, cr)
  if cr:HasUnitState(0x00008000) then 
    cr:RegisterEvent(frostboltaoe, 100, 1)
  else
    cr:CastSpell(cr:GetVictim(), spells["frostboltaoe"])
  end
end

local function coneofcold(_, _, _, cr)
  if cr:HasUnitState(0x00008000) then -- Casting
    cr:RegisterEvent(coneofcold, 100, 1)
  else
    cr:CastSpell(cr:GetVictim(), spells["coneofcold"])
  end
end

local function frostbolt(_, _, _, cr)
  if cr:HasUnitState(0x00008000) then 
    cr:RegisterEvent(frostbolt, 100, 1)
  else
    cr:CastSpell(cr:GetVictim(), spells["frostbolt"])
  end
end

local function reset(cr)
  cr:RemoveEvents()
  despawnIceSpikes(cr)
  despawnElementals(cr)
  cr:RegisterEvent(removeFrostQueensMark, 0, 1)

  cr:SetData("one", false)
  cr:SetData("two", false)
  cr:SetData("three", false)
  cr:SetData("icespikes", {})
  cr:SetData("spawnedicespikes", 0)
  cr:SetData("waterelementals", {})
end

local function registerBaseRotation(cr)
  cr:RegisterEvent(coneofcold, timers["coneofcold"], 0)
  cr:RegisterEvent(frostbolt, timers["frostbolt"], 0)
end

local function phaseOne(cr)
  registerBaseRotation(cr)
  cr:RegisterEvent(frostboltaoe, timers["frostboltaoe"], 0)

  cr:SendUnitYell("I'm not here", 0)
end

local function phaseTwo(cr)
  registerBaseRotation(cr)
  cr:RegisterEvent(frostboltaoe, timers["frostboltaoe"], 0)
  cr:RegisterEvent(icespike, timers["icespikeinterval"], 0)
end

local function phaseThree(cr)
  despawnIceSpikes(cr)
  cr:SendUnitYell("P3", 0)
  cr:RegisterEvent(spawnElementals, 0, 1)
  cr:RegisterEvent(crashingwave, 0, 1)
  cr:RegisterEvent(crashingwave, timers["crashingwave"], 0)
  registerBaseRotation(cr)
end

local function OnSpawn(event, cr)
  cr:SetData("one", false)
  cr:SetData("two", false)
  cr:SetData("three", false)
  cr:SetData("icespikes", {})
  cr:SetData("spawnedicespikes", 0)
  cr:SetData("waterelementals", {})

  cr:MoveTo(1, 1797.567383, 1368.378052, 18.8888853, true)
end

local function OnReachWP(event, cr, type, id) 
  
  if id == 1 then 
    cr:SendUnitYell("You shall not pass!", 0)
  end
end

local function OnEnterCombat(event, cr, target)
  registerBaseRotation(cr)
end

local function OnDamageTaken(event, cr, attacker, damage)
  local cHealthPct = cr:GetHealthPct()

  if cHealthPct > 60 and cHealthPct < 90 and not cr:GetData("one") then
    cr:RemoveEvents()
    phaseOne(cr)
  
    cr:SetData("one", true)
  end

  if cHealthPct > 30 and cHealthPct < 60 and not cr:GetData("two") then
    cr:RemoveEvents()
    phaseTwo(cr)

    cr:SetData("two", true)
  end

  if cHealthPct < 30 and not cr:GetData("three") then 
    cr:RemoveEvents()
    phaseThree(cr)

    cr:SetData("three", true)
  end
end

local function OnLeaveCombat(event, cr)
  reset(cr)
  cr:SetRooted(false)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  reset(cr)
  cr:SetRooted(false)
  cr:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)
RegisterCreatureEvent(npcEntry, 5, OnSpawn)
RegisterCreatureEvent(npcEntry, 6, OnReachWP)
RegisterCreatureEvent(npcEntry, 9, OnDamageTaken)
