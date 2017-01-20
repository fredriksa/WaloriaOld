local shouldGenerate = false
local shouldExecute = false
if not shouldGenerate then return end

function tableContainsKey(table, key)
  for k, v in pairs(table) do
    if key == k then 
      return true
    end
  end

  return false
end

print("########## GENERATING SPELL ITEM MANUALS ##########")
local query = WorldDBQuery("SELECT * FROM custom_spell_system")
local manuals = {}

if query then 
  repeat 
  local row = query:GetRow()

  local itemEntry = 90000 + row["id"]
  local spellLevel = tonumber(row["spellLevel"])
  if tableContainsKey(manuals, spellLevel) then
    manuals[spellLevel][#manuals[spellLevel]+1] = itemEntry
  else
    manuals[spellLevel] = {}
    manuals[spellLevel][1] = itemEntry
  end

  if shouldExecute then 
    local insertQuery = "INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `Flags`, `FlagsExtra`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `RequiredSkill`, `RequiredSkillRank`, `requiredspell`, `requiredhonorrank`, `RequiredCityRank`, `RequiredReputationFaction`, `RequiredReputationRank`, `maxcount`, `stackable`, `ContainerSlots`, `StatsCount`, `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`, `stat_type3`, `stat_value3`, `stat_type4`, `stat_value4`, `stat_type5`, `stat_value5`, `stat_type6`, `stat_value6`, `stat_type7`, `stat_value7`, `stat_type8`, `stat_value8`, `stat_type9`, `stat_value9`, `stat_type10`, `stat_value10`, `ScalingStatDistribution`, `ScalingStatValue`, `dmg_min1`, `dmg_max1`, `dmg_type1`, `dmg_min2`, `dmg_max2`, `dmg_type2`, `armor`, `holy_res`, `fire_res`, `nature_res`, `frost_res`, `shadow_res`, `arcane_res`, `delay`, `ammo_type`, `RangedModRange`, `spellid_1`, `spelltrigger_1`, `spellcharges_1`, `spellppmRate_1`, `spellcooldown_1`, `spellcategory_1`, `spellcategorycooldown_1`, `spellid_2`, `spelltrigger_2`, `spellcharges_2`, `spellppmRate_2`, `spellcooldown_2`, `spellcategory_2`, `spellcategorycooldown_2`, `spellid_3`, `spelltrigger_3`, `spellcharges_3`, `spellppmRate_3`, `spellcooldown_3`, `spellcategory_3`, `spellcategorycooldown_3`, `spellid_4`, `spelltrigger_4`, `spellcharges_4`, `spellppmRate_4`, `spellcooldown_4`, `spellcategory_4`, `spellcategorycooldown_4`, `spellid_5`, `spelltrigger_5`, `spellcharges_5`, `spellppmRate_5`, `spellcooldown_5`, `spellcategory_5`, `spellcategorycooldown_5`, `bonding`, `description`, `PageText`, `LanguageID`, `PageMaterial`, `startquest`, `lockid`, `Material`, `sheath`, `RandomProperty`, `RandomSuffix`, `block`, `itemset`, `MaxDurability`, `area`, `Map`, `BagFamily`, `TotemCategory`, `socketColor_1`, `socketContent_1`, `socketColor_2`, `socketContent_2`, `socketColor_3`, `socketContent_3`, `socketBonus`, `GemProperties`, `RequiredDisenchantSkill`, `ArmorDamageModifier`, `duration`, `ItemLimitCategory`, `HolidayId`, `ScriptName`, `DisenchantID`, `FoodType`, `minMoneyLoot`, `maxMoneyLoot`, `flagsCustom`, `VerifiedBuild`) VALUES"
    insertQuery = insertQuery..string.format("(%i, 9, 0, -1, \"Manual of %s\", 36765, 3, 64, 0, 1, 0, 0, 0, -1, -1, %i, %i, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 483, 0, -1, -1, -1, 0, -1, %i, 6, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, \"Teaches %s.\", 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 12340);", itemEntry, row["spellName"], row["spellLevel"], row["spellLevel"], row["spellID"], row["spellName"])

    WorldDBExecute(string.format("DELETE FROM item_template WHERE entry=%i", itemEntry))
    WorldDBQuery(insertQuery)
  end

  until not query:NextRow()
end


Tome = {
  entry = 0,
  requiredlevel = 0,
  manuals = {}
}

function Tome:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Tome.addManual(self, manual)
  self.manuals[#self.manuals+1] = manual
end

print("########## GENERATING TOMES ##########")

tomes = {}
for level, levelManuals in pairs(manuals) do 
  if not tableContainsKey(tomes, level) then 
    tomes[level] = Tome:new{entry = 0, requiredlevel = 0, manuals = {}}
    tomes[level].requiredlevel = level
    tomes[level].entry = 93000 + level
  end

  for i, manual in pairs(levelManuals) do 
    tomes[level]:addManual(manual)
  end
end

for i, tome in pairs(tomes) do 
  if shouldExecute == true then 
    WorldDBQuery(string.format("DELETE FROM item_template WHERE entry=%i", tome.entry))
    local name = "Dusty Tome: Chapter "..tostring(tome.requiredlevel)
    WorldDBQuery(string.format("INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `Flags`, `FlagsExtra`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `RequiredSkill`, `RequiredSkillRank`, `requiredspell`, `requiredhonorrank`, `RequiredCityRank`, `RequiredReputationFaction`, `RequiredReputationRank`, `maxcount`, `stackable`, `ContainerSlots`, `StatsCount`, `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`, `stat_type3`, `stat_value3`, `stat_type4`, `stat_value4`, `stat_type5`, `stat_value5`, `stat_type6`, `stat_value6`, `stat_type7`, `stat_value7`, `stat_type8`, `stat_value8`, `stat_type9`, `stat_value9`, `stat_type10`, `stat_value10`, `ScalingStatDistribution`, `ScalingStatValue`, `dmg_min1`, `dmg_max1`, `dmg_type1`, `dmg_min2`, `dmg_max2`, `dmg_type2`, `armor`, `holy_res`, `fire_res`, `nature_res`, `frost_res`, `shadow_res`, `arcane_res`, `delay`, `ammo_type`, `RangedModRange`, `spellid_1`, `spelltrigger_1`, `spellcharges_1`, `spellppmRate_1`, `spellcooldown_1`, `spellcategory_1`, `spellcategorycooldown_1`, `spellid_2`, `spelltrigger_2`, `spellcharges_2`, `spellppmRate_2`, `spellcooldown_2`, `spellcategory_2`, `spellcategorycooldown_2`, `spellid_3`, `spelltrigger_3`, `spellcharges_3`, `spellppmRate_3`, `spellcooldown_3`, `spellcategory_3`, `spellcategorycooldown_3`, `spellid_4`, `spelltrigger_4`, `spellcharges_4`, `spellppmRate_4`, `spellcooldown_4`, `spellcategory_4`, `spellcategorycooldown_4`, `spellid_5`, `spelltrigger_5`, `spellcharges_5`, `spellppmRate_5`, `spellcooldown_5`, `spellcategory_5`, `spellcategorycooldown_5`, `bonding`, `description`, `PageText`, `LanguageID`, `PageMaterial`, `startquest`, `lockid`, `Material`, `sheath`, `RandomProperty`, `RandomSuffix`, `block`, `itemset`, `MaxDurability`, `area`, `Map`, `BagFamily`, `TotemCategory`, `socketColor_1`, `socketContent_1`, `socketColor_2`, `socketContent_2`, `socketColor_3`, `socketContent_3`, `socketBonus`, `GemProperties`, `RequiredDisenchantSkill`, `ArmorDamageModifier`, `duration`, `ItemLimitCategory`, `HolidayId`, `ScriptName`, `DisenchantID`, `FoodType`, `minMoneyLoot`, `maxMoneyLoot`, `flagsCustom`, `VerifiedBuild`) VALUES (%i, 15, 0, -1, '%s', 55956, 3, 4, 0, 1, 0, 0, 0, -1, -1, %i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 33227, 0, -1, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 'This ancient tome is indecipherable in it''s current state.', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);", tome.entry, name, tome.requiredlevel))
  end

  --print("\n\n")
  --print("Tome "..i..": entry "..tome.entry.." reqlevel "..tome.requiredlevel)
  --print("Size: "..#tome.manuals)
  for k, manual in pairs(tome.manuals) do
    if shouldExecute == true then 
      WorldDBQuery(string.format("DELETE FROM item_loot_template WHERE Entry=%i AND Item=%i", tome.entry, manual)) 
      WorldDBQuery(string.format("INSERT INTO `item_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`,`LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES (%i, %i, 0, 0, 0, 1, 1, 1, 1, NULL);", tome.entry, manual))
    end
    --print(k.." "..manual)
  end
end

print ("########## GENERATING BOSS DROPS ##########")

function GetTomeFromLevel(level, tomes)
  if tableContainsKey(tomes, level) then 
    return tomes[level]
  else
    return GetTomeFromLevel(level-1, tomes)
  end
end

function DecideDrop(rank)
  if  rank == 1 then --Elite
    return 5
  elseif rank == 2 then  --Rare elite
    return 40
  elseif rank == 3 then  -- Boss
    return 50
  elseif rank == 4 then -- Rare
    return 40
  else
    return 5
  end
end

local query = WorldDBQuery("SELECT entry, minlevel, rank, lootid FROM creature_template WHERE rank>=1 AND minlevel>8")
if query then 
  
  WorldDBExecute("DELETE FROM creature_loot_template WHERE groupid=100");   -- Only the tome drops are stored with groupid 100

  repeat
  local row = query:GetRow()

  local entry = tonumber(row["entry"])
  local minlevel = tonumber(row["minlevel"])
  local rank = tonumber(row["rank"])
  local lootid = tonumber(row["lootid"])
  
  if minlevel > 60 then 
    minlevel = 60
  end

  if lootid == 0 then 
    lootid = 95000+entry;
    WorldDBExecute(string.format("UPDATE creature_template SET lootid=%i WHERE entry=%i", lootid, entry))
  end

  local npcTome = GetTomeFromLevel(minlevel, tomes)

  local chance = 0
  if entry > 100000 and entry < 100062 then 
    chance = 25
  else
    chance = DecideDrop(rank)
  end
  

  WorldDBExecute(string.format("INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES (%i, %i, 0, %i, 0, 1, 100, 1, 1, '')", lootid, npcTome.entry, chance))

  until not query:NextRow()
end

print ("########## EXECUTION COMPLETE ##########")
