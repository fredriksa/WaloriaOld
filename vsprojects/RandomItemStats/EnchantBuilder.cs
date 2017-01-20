using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class EnchantBuilder
    {
        public static void fill(List<SpellItemEnchantment> enchants, Item item, uint propertyID, uint builderItemVariation, uint currentVariation, DBCReader enchantReader)
        {
            uint enchantVariation = 1;
            foreach (StatPair pair in item.stats)
            {
                Stat stat = pair.stat;

                SpellItemEnchantment enchant = new SpellItemEnchantment();
                enchant.ID = DBCHelper.getNextEnchantEntry();
                enchant = setDispelTypes(enchant, item);
                enchant = setStatValues(enchant, item, pair);
                enchant = setStatTypes(enchant, item, stat);
                enchant = setUnusedValues(enchant);
                enchant = updateStatName(enchant, pair, enchantReader);
                enchants.Add(enchant);
                enchantVariation++;
            }
        }

        private static SpellItemEnchantment updateStatName(SpellItemEnchantment enchant, StatPair pair, DBCReader enchantReader)
        {
            enchant.sRefName1 = (uint)enchantReader.StringTableAdd(pair.ToString()); 
            return enchant;
        }

        //Sets all dispel types (5 == stats, 3 = spells)
        private static SpellItemEnchantment setDispelTypes(SpellItemEnchantment enchant, Item item)
        {
            enchant.spellDispelType1 = 5; //5 = Stats, 3 = spells
            return enchant;
        }

        private static SpellItemEnchantment setStatTypes(SpellItemEnchantment enchant, Item item, Stat stat)
        {
            enchant.objectId1 = (uint)stat.dbID;
            return enchant;
        }

        private static SpellItemEnchantment setStatValues(SpellItemEnchantment enchant, Item item, StatPair pair)
        {
            enchant.minAmount1 = (uint)pair.value;
            enchant.maxAmount1 = (uint)pair.value;
            return enchant;
        }

        private static SpellItemEnchantment setUnusedValues(SpellItemEnchantment enchant)
        {
            enchant.sRefName1 = 0;
            enchant.sRefName2 = 0;
            enchant.sRefName3 = 0;
            enchant.sRefName4 = 0;
            enchant.sRefName5 = 0;
            enchant.sRefName6 = 0;
            enchant.sRefName7 = 0;
            enchant.sRefName8 = 0;
            enchant.sRefName9 = 0;
            enchant.sRefName10 = 0;
            enchant.sRefName11 = 0;
            enchant.sRefName12 = 0;
            enchant.sRefName13 = 0;
            enchant.sRefName14 = 0;
            enchant.sRefName15 = 0;
            enchant.sRefName16 = 0;
            enchant.itemVisuals = 0;
            enchant.flags = 0;
            enchant.itemCache = 16712190;
            enchant.spellItemEnchantmentCondition = 0;
            enchant.skillLine = 0;
            enchant.skillLevel = 0;
            enchant.requiredLevel = 0;

            return enchant;
        }
    }
}
