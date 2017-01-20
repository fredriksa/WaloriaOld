local shouldGenerate = false
if not shouldGenerate then return end

local dustyTomeDroprate = 25
local qualityDroprate = {35, 15, 25, 5} --grey, white, green, blue

--[[
    OVERVIEW

    GetRAICreatureData()
    GetDustyTomeEntry()
    //UpdateLootTemplate() SpellManualGenerator.lua is responsible for this
    //AddDustyTomeToLoot() SpellManualGenerator.lua is responsible for this
    
    GetLootId()
    ClearFromData()
    GenerateFromData()
    Generate()
--]]

--[[
  GetRAICreatureData()
  @desc Returns creature data needed for generation
  @return {1 => {"entry" => x, "level" => Y}..}
--]]
local function GetRAICreatureData()
  local entries = {}

  local query = WorldDBQuery("SELECT rai_creature.creature_entry, creature_template.maxlevel AS level FROM rai_creature JOIN creature_template WHERE rai_creature.creature_entry = creature_template.entry;")

  if query then 
    repeat
    local row = query:GetRow()
    local data = {}
    data["entry"] = row["creature_entry"]
    data["level"] = row["level"]
    entries[#entries+1] = data
    until not query:NextRow()
  end

  return entries
end

--[[
  GetLootId()
  @desc Returns the lootId of the adventurer
  @entry The entry of the creature
  @return the generated lootId e.g 93050
--]]
local function GetLootId(entry)
  return 95000 + entry
end

--[[
  ClearFromData()
  @desc Responsible for clearing out old generation
  @data The data to clear for {"entry" => x, "level" => y}
  @return nothing
--]]
local function ClearFromData(data)
  WorldDBQuery(string.format("DELETE FROM creature_loot_template WHERE Entry=%i AND groupid=%i", GetLootId(data["entry"]), 101)) --Grey
  WorldDBQuery(string.format("DELETE FROM creature_loot_template WHERE Entry=%i AND groupid=%i", GetLootId(data["entry"]), 102)) --White
  WorldDBQuery(string.format("DELETE FROM creature_loot_template WHERE Entry=%i AND groupid=%i", GetLootId(data["entry"]), 103)) --Green
  WorldDBQuery(string.format("DELETE FROM creature_loot_template WHERE Entry=%i AND groupid=%i", GetLootId(data["entry"]), 104)) --Blue
end

local function AddItemLoot(data, quality)
  --local droprate = qualityDroprate[quality+1] -- quality worst = 0 so 1 index
  local query = WorldDBQuery(string.format("SELECT entry FROM item_template WHERE class IN (2, 4) AND subclass NOT IN (12, 11, 9) AND quality=%i AND requiredLevel=%i", quality, data["level"]))
  if query then 
    repeat
    local row = query:GetRow()

    local lootEntry = GetLootId(data["entry"])
    local itemEntry = row["entry"]

    if itemEntry < 25000 then --Try to filter out TBC items
      local droprate = 0 --Even chance for all items
      local groupId = quality + 100 + 1
      WorldDBQuery(string.format("INSERT INTO creature_loot_template VALUES (%i, %i, 0, %i, 0, 1, %i, 1, 1, '')", lootEntry, itemEntry, droprate, groupId))
    end

    until not query:NextRow()
  end
end

--[[
  GenerateData()
  @desc Generates loot for the given data table
  @data The data to generate for {"entry" => x, "level" => y}
  @return nothing
--]]
local function GenerateFromData(data)
  --AddItemLoot(data, 0)
  --AddItemLoot(data, 1)
  --AddItemLoot(data, 2)
  --AddItemLoot(data, 3) //Can include items such as field marshal leggings, raid items etc. removed
  --AddDustyTomeToLoot(data) SpellManualGenerator.lua takes care of this
end

--[[
  Generate()
  @desc Function responsible for generation
  @return nothing
--]]
local function Generate()
  local data = GetRAICreatureData()

  for k, v in ipairs(data) do
    --ClearFromData(v)
    --GenerateFromData(v)
  end

  print("#### EXECUTION RAILOOTGENERATOR COMPLETE #####")
end

Generate()