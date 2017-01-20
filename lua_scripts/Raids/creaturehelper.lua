local CreatureHelper = {}

function CreatureHelper.new()
  --[[
    PickRandomCreatureTarget
    PickRandomCReatureTargetsUnique
  --]]

  function CreatureHelper:PickRandomCreatureTarget(cr)
    local targets = cr:GetAITargets()
    local target = nil

    if #targets == 0 then 
      return false
    else
      target = targets[math.random(1, #targets)]
    end

    return target
  end
  --[[
    PickRandomCreatureTargetsUnique
    @desc Tries to get up to the amount of unique creatures, sometimes there are less returned due to there not being enough victims
    @return Table with target, nil if no targets
  --]]
  function CreatureHelper:PickRandomCreatureTargetsUnique(cr, amount)
    local targets = cr:GetAITargets()
    local selectedTargets = {}

    if #targets == 0 then 
      return nil
    end

    if #targets <= amount then 
      return targets
    end 

    while #selectedTargets < amount do
      local target = CreatureHelper:PickRandomCreatureTarget(cr)

      local found = false
      for k, guid in ipairs(selectedTargets) do 
        if guid == target:GetGUIDLow() then 
          found = true
        end
      end

      if not found then
        table.insert(selectedTargets, target)
      end
    end

    return selectedTargets
  end

  function CreatureHelper:IsCasting(cr)
    return cr:HasUnitState(32768) 
  end

  --[[
    GetCreatureNear
    @desc Fetches a creature by it's low GUID
    @return The creature or nil
  --]]
  function CreatureHelper:GetCreatureNear(cr, guid)
    local creature = nil
    local creatures = cr:GetCreaturesInRange(100)

    for i, crCandidate in ipairs(creatures) do 
      local crCandidateGUID = crCandidate:GetGUIDLow()
      if guid == crCandidateGUID then 
        creature = crCandidate
        return creature
      end
    end
    
    return creature
  end

  --[[
    GetCreatureNearEntry
    @desc Fetches a creature near by it's entry
    @return The creature or nil
  --]]
  function CreatureHelper:GetCreatureNearEntry(cr, entry)
    local creature = nil
    local creatures = cr:GetCreaturesInRange(100)

    for i, crCandidate in ipairs(creatures) do 
      local candidateEntry = crCandidate:GetEntry()
      if entry == candidateEntry then 
        creature = crCandidate
        return creature
      end
    end
    
    return creature
  end

  --[[
    IsOnGround
    @desc Returns whether or not the player is on the ground
    @return True or false
  --]]
  function CreatureHelper:IsOnGround(player)
    if player:IsFalling() or player:IsFlying() then 
      return false
    end

    return true
  end

  --[[
    DespawnCreatureTable
    @desc Despawns all the creatures with GUIDs found in the table
    @return nothing
  --]]
  function CreatureHelper:DespawnCreatureTable(cr, guids)
    if not guids then return end

    for k, guid in ipairs(guids) do 
      local creature = CreatureHelper:GetCreatureNear(cr, guid)

      if creature then 
        creature:DespawnOrUnsummon()
      end
    end
  end

  return CreatureHelper
end

return CreatureHelper