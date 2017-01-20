class WeaponToken
  attr_accessor :ilevel, :entry, :bonding, :slot, :subclass, :quality,
                :start_entry, :end_entry

  def generate_query(params)
    "INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `Flags`, `FlagsExtra`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `RequiredSkill`, `RequiredSkillRank`, `requiredspell`, `requiredhonorrank`, `RequiredCityRank`, `RequiredReputationFaction`, `RequiredReputationRank`, `maxcount`, `stackable`, `ContainerSlots`, `StatsCount`, `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`, `stat_type3`, `stat_value3`, `stat_type4`, `stat_value4`, `stat_type5`, `stat_value5`, `stat_type6`, `stat_value6`, `stat_type7`, `stat_value7`, `stat_type8`, `stat_value8`, `stat_type9`, `stat_value9`, `stat_type10`, `stat_value10`, `ScalingStatDistribution`, `ScalingStatValue`, `dmg_min1`, `dmg_max1`, `dmg_type1`, `dmg_min2`, `dmg_max2`, `dmg_type2`, `armor`, `holy_res`, `fire_res`, `nature_res`, `frost_res`, `shadow_res`, `arcane_res`, `delay`, `ammo_type`, `RangedModRange`, `spellid_1`, `spelltrigger_1`, `spellcharges_1`, `spellppmRate_1`, `spellcooldown_1`, `spellcategory_1`, `spellcategorycooldown_1`, `spellid_2`, `spelltrigger_2`, `spellcharges_2`, `spellppmRate_2`, `spellcooldown_2`, `spellcategory_2`, `spellcategorycooldown_2`, `spellid_3`, `spelltrigger_3`, `spellcharges_3`, `spellppmRate_3`, `spellcooldown_3`, `spellcategory_3`, `spellcategorycooldown_3`, `spellid_4`, `spelltrigger_4`, `spellcharges_4`, `spellppmRate_4`, `spellcooldown_4`, `spellcategory_4`, `spellcategorycooldown_4`, `spellid_5`, `spelltrigger_5`, `spellcharges_5`, `spellppmRate_5`, `spellcooldown_5`, `spellcategory_5`, `spellcategorycooldown_5`, `bonding`, `description`, `PageText`, `LanguageID`, `PageMaterial`, `startquest`, `lockid`, `Material`, `sheath`, `RandomProperty`, `RandomSuffix`, `block`, `itemset`, `MaxDurability`, `area`, `Map`, `BagFamily`, `TotemCategory`, `socketColor_1`, `socketContent_1`, `socketColor_2`, `socketContent_2`, `socketColor_3`, `socketContent_3`, `socketBonus`, `GemProperties`, `RequiredDisenchantSkill`, `ArmorDamageModifier`, `duration`, `ItemLimitCategory`, `HolidayId`, `ScriptName`, `DisenchantID`, `FoodType`, `minMoneyLoot`, `maxMoneyLoot`, `flagsCustom`, `VerifiedBuild`)" +
    "VALUES (#{entry}, 15, 0, -1, '" + name(params) + "', 38160, #{quality_id}, 4, 0, 1, 0, 0, 0, -1, -1, 0, 0, 0, 0, 0, 0, 0, " + 
    "0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, " +
    "0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 33227, 0, -1, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, " + 
    "0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, #{bonding_id}, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, " + 
    "0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0);"
  end

  def loot_query(params)
    start_entry = params['id'].to_i
    end_entry = params['id'].to_i + params['amount'].to_i
    
    loot_query = ""
    for i in start_entry..end_entry-1
      modifier = 0
      if not params['token_loot_distance_start'].nil?
        modifier += params['token_loot_distance_start'].to_i
      end

      loot_query += "INSERT INTO `item_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`,`LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES (#{entry}, #{i + modifier}, 0, 0, 0, 1, 1, 1, 1, NULL);"
    end

    loot_query
  end

  # Returns the display ID
  def displayid
    Display.all(class_id: 15, subclass_id: 0).sample.displayid
  end

  # Returns the bonding ID
  def bonding_id
    Bond.first(name: self.bonding).db_id
  end

  # Returns the slot's DB id
  def quality_id
    Quality.first(name: self.quality).db_id
  end

  def slot_name
    Slot.first(name: self.slot).name
  end

  def name(params)
    # This prevents us from having a token with the name of for instance
    # "Shield Shield Item Level 27-30"
    subclass_slot_string = ""

    if subclass == slot 
      subclass_slot_string = "#{slot.to_s.capitalize_first}"
    else
      subclass_slot_string = "#{slot.to_s.capitalize_first} #{subclass.to_s.capitalize_first}"
    end

    "#{subclass_slot_string} #{ilevel_string(params)}"
  end

  def ilevel_string(params)
    "Item Level #{ItemLevel.calculate(params)}"
  end
end