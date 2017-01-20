local spellclass = require("/SpellAIO/spellclass").new()
local removeSpells = {}

function tableContainsKey(table, key)
  for k, v in pairs(table) do
    if key == k then 
      return true
    end
  end

  return false
end

local function LoadTomes()
  local foundTomes = {}

  local query = WorldDBQuery("SELECT * FROM item_template WHERE entry > 93000 and entry < 93061")
  if query then 
    repeat

    local row = query:GetRow()

    local level = row["entry"]-93000
    foundTomes[level] = row["entry"]

    until not query:NextRow()
  end

  return foundTomes
end

local function GetTomeForLevel(level, tomes)
  if tableContainsKey(tomes, level) then 
    return tomes[level]
  else
    return GetTomeForLevel(level-1, tomes)
  end
end

local function ComputeTomeItemIDFromSpellID(spellID)
  return 90000 + spellID
end

local tomes = LoadTomes()

local function ExecuteCommand(event, player, command)
  if not player:IsGM() then return true end 

  if string.find(command, "remove spell") then 
    local spellID = tonumber(tostring(string.gsub(command, "remove spell ", "")))

    if not spellID then 
      player:SendBroadcastMessage("Error: Must provide spellID (e.g .remove spell 1330)")
      return false
    end

    table.insert(removeSpells, spellID)

    -- Get spell level from custom_spell_system
    local query = WorldDBQuery(string.format("SELECT * FROM custom_spell_system WHERE spellID=%i", spellID))
    spell = {}
    if query then 
      local row = query:GetRow()
      spell["level"] = row["spellLevel"]
      spell["name"] = row["spellName"]
    else
      player:SendBroadcastMessage("Info: Spell not in table custom_spell_system.")
      return false
    end

    -- Modify custom tables
    --WorldDBExecute(string.format("DELETE FROM custom_spell_system WHERE spellID=%i", spellID))
    --WorldDBExecute(string.format("DELETE FROM custom_banned_spell_system WHERE spellID=%i", spellID))
    --WorldDBExecute(string.format("INSERT INTO custom_banned_spell_system VALUES (%i)", spellID))

    -- Grab all characters GUIDs with spell
    characters = {}
    local query = CharDBQuery(string.format("SELECT * FROM character_spell WHERE spell=%i", spellID))
    if query then 
      repeat
      local row = query:GetRow()
      characters[#characters+1] = row["guid"]

      until not query:NextRow()
    else
        player:SendBroadcastMessage(string.format("Info: No characters found with spellID=%i.", spellID))
    end

    -- Remove spell from online characters
    local players = GetPlayersInWorld()

    for i=1, #players do 
      local targetPlayer = players[i]

      if targetPlayer:HasSpell(spellID) then 
        targetPlayer:RemoveSpell(spellID)
        targetPlayer:SaveToDB()
      end
    end

    -- Delete all entries for the spell in character_spell (offline characters)
    --CharDBExecute(string.format("DELETE FROM character_spell where spell=%i", spellID))

    -- Delete manual from DB
    --local manualID = spellclass:ComputeTomeItemIDFromSpellID(spellID)
    --WorldDBExecute("DELETE FROM item_template WHERE entry="..spellID)

    -- Mail tomes to affected characters
    for i=1, #characters do 
      local receiver = characters[i]
      local sender = player:GetGUIDLow()

      local subject = "Compensation For Removed Spell"
      local message = "A spell that your character used to know has been removed from Waloria.\n\nSpell Name: "..spell["name"].."\nSpell Level: "..spell["level"]

      local tomeID = GetTomeForLevel(spell["level"], tomes)

      SendMail(subject, message, receiver, sender, 61, 0, 0, 0, tomeID, 3)
    end

    player:SendBroadcastMessage(string.format("Info: Removed spell with spellID %i for %i characters.", spellID, #characters))

    return false
  end
end

local function OnShutDown()
  print("Shutdown")
  for k, spellID in ipairs(removeSpells) do
    print("REMOVED SPELLID: "..spellID)

    --Remove from online players when shutting down as well
    local players = GetPlayersInWorld()

    for i=1, #players do 
      local targetPlayer = players[i]

      if targetPlayer:HasSpell(spellID) then 
        targetPlayer:RemoveSpell(spellID)
        targetPlayer:SaveToDB()
      end
    end

    --Insert into custom_banned_spell_system
    WorldDBExecute(string.format("DELETE FROM custom_banned_spell_system WHERE spellID=%i", spellID))
    WorldDBExecute(string.format("INSERT INTO custom_banned_spell_system VALUES (%i)", spellID))

    --Delete known spells from character
    CharDBExecute(string.format("DELETE FROM character_spell where spell=%i", spellID))
    --Delete manual from DB, manual ID depends on table, so we must delete from custom_spell_system later
    local manualID = spellclass:ComputeTomeItemIDFromSpellID(spellID)
    print("Manual ID: "..manualID)
    WorldDBExecute("DELETE FROM item_template WHERE entry="..manualID)

    --Delete from custom_spell_system
    WorldDBExecute(string.format("DELETE FROM custom_spell_system WHERE spellID=%i", spellID))
  end
end

RegisterServerEvent(11, OnShutDown)
RegisterPlayerEvent(42, ExecuteCommand)