local SpellClass = {}

function SpellClass.new()
  function SpellClass:SelectSpellsFromPool(spellPool, amount)
    local spells = {}

    for i = 1, amount do 
      local spellIndex = math.random(1, #spellPool)  -- Select random spell index
      local selectedSpell = spellPool[spellIndex] -- Obtain selected spell
    
    -- While we've selected a spell that have already been selected - keep re-selecting
      while SpellClass:IsNumberPartOfArray(selectedSpell, spells) do 
        spellIndex = math.random(1, #spellPool) -- Select random spell index
        selectedSpell = spellPool[spellIndex] -- Obtain selected spell
      end

      spells[i] = selectedSpell -- 
    end

    return spells
  end

  function SpellClass:IsNumberPartOfArray(number, array)
    for i = 1, #array do 
      if number == array[i] then 
        return true
      end
    end

    return false
  end

  --
  function SpellClass:RandomPlayerSpellSelection(player, category, level)
    local spellPool = nil

    if level > 0 then 
      spellPool = SpellClass:SpellCandidatesAroundLevel(player, level, category)
    else
      spellPool = SpellClass:SpellCandidatesAroundLevel(player, player:GetLevel(), category)
    end

    local spells = SpellClass:SelectSpellsFromPool(spellPool, 4)
    return spells
  end

  --Grabs spell candidates around the level.
  function SpellClass:SpellCandidatesAroundLevel(player, level, category)
    local minSpells = 6
    local spells = {}

    local currLevel = level; -- 29
    while #spells < minSpells and currLevel >= 1 do  -- true
      local queryString = string.format("SELECT custom_spell_system.spellID, custom_spell_system.spellLevel, custom_spell_system_categories.category FROM custom_spell_system INNER JOIN custom_spell_system_categories ON custom_spell_system.spellID = custom_spell_system_categories.spellID WHERE spellLevel=%i and category=%i;", currLevel, category)
      local query = WorldDBQuery(queryString)
      if query then 
        repeat 
          local row = query:GetRow()
          
          --Don't let spells which player already has become a option
          if not player:HasSpell(tonumber(row["spellID"])) then
            spells[#spells+1] = row["spellID"]
          end

        until not query:NextRow()
      end

      currLevel = currLevel - 1
    end

    return spells
  end

  -- Returns all categories where 4 or more spells exists for choosing
  function SpellClass:GetAvailableCategories(player)
    local level = player:GetLevel()
    local availableCategories = {}

    for i=1, 4 do 
      if SpellClass:ExistsSpellCandidates(player, level, i) then
        availableCategories[i] = i
      end
    end

    return availableCategories
  end

  function SpellClass:ExistsSpellCandidates(player, level, category)
    local queryString = string.format("SELECT custom_spell_system.spellID, custom_spell_system.spellLevel, custom_spell_system_categories.category FROM custom_spell_system INNER JOIN custom_spell_system_categories ON custom_spell_system.spellID = custom_spell_system_categories.spellID WHERE spellLevel<=%i and category=%i;", level, category)
    local query = WorldDBQuery(queryString)

    local nRows = 0

    if query then 
      repeat
        local row = query:GetRow()
        nRows = nRows + 1
      until not query:NextRow()
    end

    if nRows >= 4 then 
      return true
    end

    return false
  end

  --Saves the table of spell choices in the DB from the player
  function SpellClass:SaveSpellChoices(player, spells)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)
    local saveQuery = string.format("INSERT INTO custom_spell_system_choices VALUES (%i, %i, %i, %i, %i, %i)", charGUID, player:GetLevel(), spells[1], spells[2], spells[3], spells[4])
    WorldDBExecute(saveQuery)
  end

  --Saves category choice in the DB from the player
  function SpellClass:SaveCategoryChoice(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)
    local saveQuery = string.format("INSERT INTO custom_spell_system_category_choices (characterGUID, level) VALUES (%i, %i)", charGUID, player:GetLevel())
    WorldDBExecute(saveQuery)
  end

  --Checks if the player has a category choice
  function SpellClass:HasCategoryChoice(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)
    query = WorldDBQuery(string.format("SELECT * FROM custom_spell_system_category_choices WHERE characterGUID=%i", charGUID))

    if query then 
      return true
    end

    return false
  end

  --Gets next character choice from DB
  function SpellClass:GetNextCategoryChoice(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)
    query = WorldDBQuery(string.format("SELECT * FROM custom_spell_system_category_choices WHERE characterGUID=%i", charGUID))

    if query then 
      return query:GetRow()
    end

    return nil
  end

  --Deletes next category choice
  function SpellClass:DeleteNextCategoryChoice(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)
    query = WorldDBQuery(string.format("SELECT * FROM custom_spell_system_category_choices WHERE characterGUID=%i", charGUID))

    local id = nil
    if query then 
      local row = query:GetRow()

      id = tonumber(row["id"])
    end

    WorldDBExecute(string.format("DELETE FROM custom_spell_system_category_choices WHERE characterGUID=%i AND id=%i", charGUID, id))
  end

  -- Returns the character GUID (characters.guid table) from the players current character
  function SpellClass:GetPlayerCharacterGUID(player)
    query = CharDBQuery(string.format("SELECT guid FROM characters WHERE name='%s'", player:GetName()))

    if query then 
      local row = query:GetRow()

      return tonumber(row["guid"])
    end

    return nil
  end

  -- Checks if player have spell choices to do.
  function SpellClass:HasSpellChoices(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)
    query = WorldDBQuery(string.format("SELECT * FROM custom_spell_system_choices WHERE characterGUID=%i", charGUID))

    if query then 
      return true
    end

    return false
  end

  -- Gets the new spell selection spell IDs, sorted by level (i.e level 1 selection should be made before level 2)
  function SpellClass:GetNextSpellChoiceFromDB(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)

    query = WorldDBQuery(string.format("SELECT * FROM custom_spell_system_choices WHERE characterGUID=%i ORDER BY level;", charGUID))

    if query then
      local row = query:GetRow()

      local spells = {}
      spells[1] = row["spellID1"]
      spells[2] = row["spellID2"]
      spells[3] = row["spellID3"]
      spells[4] = row["spellID4"]

      return spells
    end
  end

  function SpellClass:DeleteNextSpellChoiceFromDB(player)
    local charGUID = SpellClass:GetPlayerCharacterGUID(player)

    query = WorldDBQuery(string.format("SELECT * FROM custom_spell_system_choices WHERE characterGUID=%i ORDER BY level;", charGUID))

    local level = nil
    if query then
      local row = query:GetRow()
      level = row["level"]
    end

    WorldDBExecute(string.format("DELETE FROM custom_spell_system_choices WHERE characterGUID=%i AND level=%i", charGUID, level))
  end

  -- Making sure that the player is learning a spell he should be able to learn
  function SpellClass:CanLearnSpellFromNextChoice(player, spellID)
    local spells = SpellClass:GetNextSpellChoiceFromDB(player)

    for i=1, 4 do 
      if spells[i] == spellID then 
        return true
      end
    end

    return false
  end

  --Deletes all spell choices for characterGUID
  function SpellClass:DeleteAllSpellChoicesFromDB(characterGUID)
    WorldDBExecute(string.format("DELETE FROM custom_spell_system_choices WHERE characterGUID=%i", characterGUID))
  end

  function SpellClass:ValidSpellToRemove(spellID)
    local query = WorldDBQuery(string.format("SELECT * FROM custom_spell_system WHERE spellID=%i", spellID))

    if query then 
      return true
    end

    return false
  end

  function SpellClass:ComputeTomeItemIDFromSpellID(spellID)
    local query = WorldDBQuery(string.format("SELECT id FROM custom_spell_system WHERE spellID=%i", spellID))
    
    if query then
      local row = query:GetRow()
      return 90000 + row["id"]
    end

    return nil
  end

  function SpellClass:GetMaxCustomSpellAmount()
    return 25
  end

  function SpellClass:CanLearnCustomSpell(player)
    --player:SaveToDB()
    --player:UpdateCustomSpellAmount()

    local newAmount = player:GetCustomSpellAmount() + 1
    if newAmount > SpellClass:GetMaxCustomSpellAmount() then 
      return false
    end

    return true
  end

  return SpellClass
end

return SpellClass