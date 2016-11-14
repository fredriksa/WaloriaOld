-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 100007

local creatures = {
  ["infernalball"] = 100003,
}

local spells = {
  ["camerashake"] = 69235,
}

local movementPath = {
  [1] = {1, 56.341835, 121.857231, 83.545624},
  [2] = {2, 24.506247, 158.195282, 83.545624},
  [3] = {3, -3.581095, 120.810921, 83.545624},
  [4] = {4, -30.634377, 162.363220, 83.545723},
  [5] = {5, -52.241520, 138.573486, 83.545624},
  [6] = {6, -34.158676, 120.475624, 83.546471},
  [7] = {7, -6.167376, 162.789291, 83.545639},
  [8] = {8, 21.290506, 126.409035, 83.545715},
  [9] = {9, 29.998611, 155.795044, 83.545609},
  [10] = {10, 56.341835, 121.857231, 83.545624},
}

local nInfernalsOnSpawn = 6 -- Max is #movementPath
local heightModifier = 20

local function nextMoveId(creature)
  local spawnedAt = creature:GetData("spawnedAt") 
  local id = math.random(1, #movementPath) 

  if spawnedAt[id] == true then 
    return nextMoveId(creature)
  end

  spawnedAt[id] = true
  creature:SetData("spawnedAt", spawnedAt)
  return id
end

local function despawnInfernals(creature)
  local creaturesNear = creature:GetCreaturesInRange(150, creatures["infernalball"])
  local infernalballGUIDs = creature:GetData("infernalballGUIDs")

  for _, ball in pairs(creaturesNear) do 
    for _, infernalballGUID in pairs(infernalballGUIDs) do
      if ball:GetGUIDLow() == infernalballGUID then 
        ball:DespawnOrUnsummon(0)
      end
    end
  end
end

local function spawnInfernals(_, _, _, creature)
  for i = 0, nInfernalsOnSpawn, 1 do 
    local movementPathIndex = nextMoveId(creature)
    local nextMove = movementPath[movementPathIndex]

    local id = nextMove[1]
    local x = nextMove[2]
    local y = nextMove[3]
    local z = nextMove[4] + heightModifier

    local infernalball = creature:SpawnCreature(creatures["infernalball"], x, y, z, 0, 2, 300000)
    infernalball:MoveTo(id, nextMove[2], nextMove[3], nextMove[4])

    local infernalballGUIDs = creature:GetData("infernalballGUIDs")
    table.insert(infernalballGUIDs, infernalball:GetGUIDLow())
    creature:SetData("infernalballGUIDs", infernalballGUIDs)
  end
end

local function OnSpawn(event, creature)
  if creature:IsAlive() then 
    creature:SetData("infernalballGUIDs", {})
    creature:SetData("spawnedAt", {})

    creature:RegisterEvent(spawnInfernals, 0, 1)

    for _, player in pairs(creature:GetPlayersInRange(150)) do 
      player:CastSpell(player, spells["camerashake"], true)
    end
  end
end

local function OnDied(event, creature, killer)
  despawnInfernals(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(npcEntry, 5, OnSpawn)
RegisterCreatureEvent(npcEntry, 4, OnDied)