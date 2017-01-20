local helper = require("../creaturehelper").new()
local npcEntry = 96007

local spells = {}
local timers = {}
local creatures = {}

spells["immolate"] = 93012
spells["hellfire"] = 93015
spells["orangearrow"] = 93019
spells["chainfireball"] = 93022
spells["purge"] = 93024

timers["immolate"] = 18000
timers["hellfire"] = 35000
timers["chainfireball"] = 3000
timers["spawnfire"] = 1000
timers["pickfiretarget"] = 20000
timers["spawnfireshields"] = 10000
timers["purge"] = 6000

creatures["firetrigger"] = 96009
creatures["fireshieldtrigger"] = 96010

local fireshieldSpawnPoints = {
  [1] = {144.976410, -233.283905, 91.544228},
  [2] = {154.540802, -240.562012, 91.197899},
  [3] = {154.867355, 91.551132, 4.261643},
  [4] = {156.051697, -272.467407, 91.567421},
  [5] = {140.756760, -281.138702, 91.555695},
  [6] = {135.336777, -269.559509, 91.551422},
  [7] = {122,248749, -278.155304, 91.550552},
  [8] = {126.543465, -265.554474, 91.209229},
  [9] = {133.941025, -257.256470, 91.551346},
  [10] = {126.609711, -248.008408, 2.185824},
  [11] = {137.199966, -245.935959, 91.549820},
  [12] = {122.625816, -235.803375, 91.541359},
  [13] = {136.223053, -240.713333, 91.194756},
  [14] = {146.339401, -248.849548, 91.552437},
  [15] = {168.313782, -238.765701, 91.539101},
  [16] = {167.926331, -255.778442, 91.545143},
  [17] = {165.867172, -262.409576, 91.538834},
  [18] = {162.239746, -270.339752, 91.246307},
  [19] = {152.367218, -266.286835, 91.553040},
  [20] = {119.310783, -238.352829, 91.545616}
}

local function chainfireball(_, _, _, cr)
  if helper:IsCasting(cr) then 
    return
  end

  cr:CastSpellRAI(cr:GetVictim(), spells["chainfireball"], true)
end

local function immolation(_, _, _, cr)
  if helper:IsCasting(cr) then 
    cr:RegisterEvent(immolation, 100, 1)
    return
  end

  local targets = helper:PickRandomCreatureTargetsUnique(cr, 3)

  for k, target in ipairs(targets) do 
    if not targets then return end
    for i, player in ipairs(cr:GetPlayersInRange(100)) do 

      if player ~= nil and player:GetGUIDLow() == target:GetGUIDLow() then 
        cr:CastSpellRAI(player, spells["immolate"], true)
      end
    end
  end
end

local function hellfire(_, _, _, cr)
  if helper:IsCasting(cr) then 
    cr:RegisterEvent(hellfire, 100, 1)
    return
  end

  cr:CastSpellRAI(cr, spells["hellfire"], true)
end

local function spawnFireTarget(_, _, _, cr)
  local target = helper:PickRandomCreatureTarget(cr)
  cr:AddAura(spells["orangearrow"], target)
end

local function spawnFire(_, _, _, cr)
  for i, v in ipairs(cr:GetPlayersInRange(100)) do 
    if v:HasAura(spells["orangearrow"]) then 
      if v:IsFalling() or v:IsFlying() then 
        cr:RegisterEvent(spawnFire, 50, 1)
        return
      end

      cr:SpawnCreature(creatures["firetrigger"], v:GetX(), v:GetY(), v:GetZ(), v:GetO(), 2, 300000)
    end
  end
end

local function spawnfireshields(_, _, _, cr)
  local spawnedIndexes = cr:GetData("spawnedIndexes")
  if spawnedIndexes == nil then spawnedIndexes = {} end

  local nrOfShields = 10
  for i=1, nrOfShields do 
    --Get a non-spawned spawn point
    local legitIndex = false
    local randomIndex = nil
    while not legitIndex do 
       randomIndex = math.random(1, #fireshieldSpawnPoints)

      if spawnedIndexes[randomIndex] == nil then 
        legitIndex = true
      end
    end

    local pos = fireshieldSpawnPoints[randomIndex]

    --Spawn creature
    cr:SpawnCreature(creatures["fireshieldtrigger"], pos[1], pos[2], pos[3], 0, 2, 300000)
  end

  cr:SetData("spawnedIndexes", spawnedIndexes)
end

local function purge(_, _, _, cr)
  if helper:IsCasting(cr) then 
    cr:RegisterEvent(purge, 100, 1)
    return
  end

  cr:CastSpell(cr:GetVictim(), spells["purge"], true)
end

local function OnEnterCombat(event, cr, target)
  cr:SetData("spawnedIndexes")
  cr:RegisterEvent(spawnfireshields, timers["hellfire"]-2000, 0)
  cr:RegisterEvent(hellfire, timers["hellfire"], 0)
  cr:RegisterEvent(immolation, 0, 1)
  cr:RegisterEvent(immolation, timers["immolate"], 0)
  cr:RegisterEvent(spawnFireTarget, timers["pickfiretarget"], 0)
  cr:RegisterEvent(spawnFire, timers["spawnfire"], 0)
  cr:RegisterEvent(chainfireball, timers["chainfireball"], 0)
  cr:RegisterEvent(purge, timers["purge"], 0)
end

local function OnLeaveCombat(event, cr)
  cr:RemoveEvents()
end

local function OnDied(event, cr, killer)
  cr:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 1, OnEnterCombat)
RegisterCreatureEvent(npcEntry, 2, OnLeaveCombat)
RegisterCreatureEvent(npcEntry, 4, OnDied)