local objectEntry = 175706
local objects = {}

objects["instanceportalred"] = 507902

local function checkStatus(event, delay, pCall, obj)
  print("0")
  local players = obj:GetPlayersInRange(100)

  print("1")
  local fightOver = true
    
  --If all players are dead then fight is over
  local anyoneAlive = false
  for k, player in ipairs(players) do 
    if player:IsAlive() then 
      anyoneAlive = true
    end
  end

    print("2")

  if anyoneAlive then fightOver = false end

  if fightOver then 

      print("3")
    --Despawn portal
    if obj:GetData("portalGUID") then 
      for k, object in ipairs(obj:GetGameObjectsInRange(100)) do 
        if obj:GetData("portalGUID") == object:GetGUIDLow() then 
          object:DespawnOrUnsummon(1)
          print("depsawning portal")
        end
      end
    end

    --Reset object data
    obj:SetData("portalGUID", nil)
    obj:SetData("started", nil)
      print("5 end")
  end
end

local function summonPortal(obj)
  local portal = obj:SummonGameObject(objects["instanceportalred"], 144.226700, -253.448364, 97.273537, 1.574291)
  obj:SetData("portalGUID", portal:GetGUIDLow())
end

local function closeDoors(obj)
  for k, object in ipairs(obj:GetGameObjectsInRange(100)) do 
    if object:GetDBTableGUIDLow() == 87842 then 
      object:UseDoorOrButton(0) -- Permanently closes door
    end
  end
end

local function OnStart(event, player, obj)
  if not obj:GetData("started") then
    obj:RegisterEvent(checkStatus, 1, 0)
    print("spawning")
    summonPortal(obj)
    closeDoors(obj)
    obj:SetData("started", true)
  else
    player:SendBroadcastMessage("Object has already been used")
  end
end

RegisterGameObjectGossipEvent(objectEntry, 1, OnStart)