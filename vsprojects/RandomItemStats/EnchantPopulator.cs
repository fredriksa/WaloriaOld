using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class EnchantPopulator
    {
        public const int enchantVariations = 501; //501 = 1-500 (e.g 1 stamina, 2 stamina.. 500 stamina)
        private static DBCReader enchantReader;

        public static List<SpellItemEnchantment> populate(DBCReader newEnchantReader)
        {
            enchantReader = newEnchantReader;
            List<SpellItemEnchantment> enchants = new List<SpellItemEnchantment>();
            Dictionary<int, List<SpellItemEnchantment>> enchanctDict = new Dictionary<int, List<SpellItemEnchantment>>();

            foreach(KeyValuePair<int, Stat> pair in StatContainer.stats)
            {
                if (pair.Value.dbID > 0) //Ignore unknown stat
                {
                    List<SpellItemEnchantment> statEnchants = populateStat(pair.Value);
                    enchants.AddRange(statEnchants);
                    enchanctDict.Add(pair.Value.dbID, statEnchants);
                }
            }


            //Save in enchant container before returning and writing to DBC files
            EnchantContainer.enchants = enchanctDict;
            return enchants;
        }

        //Populates spellitemenchantment.dbc with entries from stat
        private static List<SpellItemEnchantment> populateStat(Stat stat)
        {
            List<SpellItemEnchantment> enchants = new List<SpellItemEnchantment>();

            for (int i = 0; i < enchantVariations; i++)
            {
                StatPair pair = new StatPair(stat, i, stat.dbID);

                SpellItemEnchantment enchant = new SpellItemEnchantment();
                enchant.ID = DBCHelper.getNextEnchantEntry();
                enchant.sRefName1 = (uint)enchantReader.StringTableAdd(pair.ToString());
                enchant.spellDispelType1 = 5;
                enchant.objectId1 = (uint)stat.dbID;
                enchant.minAmount1 = (uint)i;
                enchant.maxAmount1 = (uint)i;
                enchant.itemCache = 16712190;
                enchants.Add(enchant);
            }

            return enchants;
        }
    }
}
