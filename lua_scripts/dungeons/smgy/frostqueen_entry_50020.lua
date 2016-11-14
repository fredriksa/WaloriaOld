-- Code written by Fractional @Ac-web.org
-- Release: https://github.com/Freddan962/ElunaScripts

local npcEntry = 50020
local frostqueenEntry = 50010

local objects = {}
objects["portal"] = 535622

local function despawnPortal(_, _, _, cr)
  local gameObjects = cr:GetGameObjectsInRange(300, objects["portal"])

  if gameObjects then 
    for _, gameObject in pairs(gameObjects) do
      if gameObject:GetGUIDLow() == cr:GetData("portalGUID") then 
        gameObject:Despawn(0)
      end
    end
  end
end

local function spawnFrostqueen(_, _, _, cr)
  local frostqueen = cr:SpawnCreature(frostqueenEntry, 1797.548950, 1383.566895, 18.759863, 4.753486)
  cr:SetData("frostQueenGUID", frostqueen:GetGUIDLow())
end

local function spawnPortal(_, _, _, cr)
  local portal = cr:SummonGameObject(objects["portal"], 1797.810181, 1384.827148, 18.727154, 4.748721, 300000000)
  cr:SetData("portalGUID", portal:GetGUIDLow())
end

local function onFightOver(_, _, _, cr)
  cr:RegisterEvent(despawnPortal, 5, 1)
end

local function update(_, _, _, cr)
  local frostqueen = cr:GetCreaturesInRange(300, frostqueenEntry, 0, 2) -- Tries to grab the dead frostqueen

  if cr:GetData("fightOver") == false and next(frostqueen) then 
    cr:SetData("fightOver", true)
    cr:RegisterEvent(onFightOver, 5, 1)
  end
end

local function startCheck(_, _, _, cr)
  local players = cr:GetPlayersInRange(60)

  if next(players) ~= nil and not cr:GetData("started") then 
    cr:SetData("started", true)
    cr:RegisterEvent(update, 1000, 0)
    cr:RegisterEvent(spawnPortal, 5, 1)
    cr:RegisterEvent(spawnFrostqueen, 1500, 1)

    cr:SendUnitYell("STARTED", 0)
  end
end

local function OnSpawn(event, cr)
  cr:SetData("started", false)
  cr:SetData("fightOver", false)
  cr:RegisterEvent(startCheck, 500, 0)
end

RegisterCreatureEvent(npcEntry, 5, OnSpawn)

-- Icebolt with stun: 22357
-- Frostbolt: 72501
-- Frostbolt AoE with manadrain/slow: 72015 
-- Blizzard AoE around self: 70421 (maybe to make melees stop attacking boss in phase?)
-- Crashing wave 57652