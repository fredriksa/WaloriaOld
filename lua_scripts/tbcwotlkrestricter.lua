function tableContainsKey(table, key)
  for k, v in pairs(table) do
    if key == k then 
      return true
    end
  end

  return false
end

local teleportPos = {
  ["outland"] = {0, -11877.700195, -3204.489990, -18.502022, 0.190730}
}

local function OnZoneChange(event, player, newZone, newArea)
  local bannedZones = {
    [3483] = teleportPos["outland"], --Hellfire
    [3703] = teleportPos["outland"], --Shattrath
  }

  if not player:IsGM() then
    if tableContainsKey(bannedZones, newZone) then
      local pos = bannedZones[newZone]
      player:Teleport(pos[1], pos[2], pos[3], pos[4], pos[5])
    end
  end
end

RegisterPlayerEvent(27, OnZoneChange)

local function OnMapChange(event, player)
  local bannedMaps = {
    -- [530] = teleportPos["outland"], --Outland base map  (BE and Draenei have 530 as map ID)
    [543] = teleportPos["outland"], -- Hellfire citadel ramparts
    [542] = teleportPos["outland"], -- Blood furnace
    [547] = teleportPos["outland"], -- Coilfang the slave pens
  }
    
  if not player:IsGM() then 
    local playerMap = player:GetMap():GetMapId()

    if tableContainsKey(bannedMaps, playerMap) then 
      local pos = bannedMaps[playerMap]
      player:Teleport(pos[1], pos[2], pos[3], pos[4], pos[5])
    end

  end
end

RegisterPlayerEvent(28, OnMapChange)

local function OnMapChangeNorthrend(event, player)
    
    if not player:IsGM() then 
      local playerMap = player:GetMap():GetMapId()

      if playerMap == 571 then 
        if player:GetTeam() == 1 then 
          player:Teleport(0, 2061.126221, 359.907166, 82.486397, 1.885127)
        elseif player:GetTeam() == 0 then 
          player:Teleport(0, -8290.857422, 1398.748047, 4.772235, 4.730891)
        end
      end
    end

end

RegisterPlayerEvent(28, OnMapChangeNorthrend)