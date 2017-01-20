using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class VariationBuilder
    {
        public static void fill(List<Variation> variations, List<Item> itemVariations, DBCReader enchantReader, int currentItemVariation)
        {
            int builderItemVariation = 1;
            foreach (Item item in itemVariations)
            {
                Variation variation = new Variation();
                variation.property.ID = calculatePropertyID(item, builderItemVariation, currentItemVariation);

                if (item.stats.ToArray().Length > 0)
                    variation.enchants.Add(EnchantContainer.get(item.stats[0]));

                if (item.stats.ToArray().Length > 1)
                    variation.enchants.Add(EnchantContainer.get(item.stats[1]));

                if (item.stats.ToArray().Length > 2)
                    variation.enchants.Add(EnchantContainer.get(item.stats[2]));

                //EnchantBuilder.fill(variation.enchants, item, variation.property.ID, (uint)builderItemVariation, (uint)currentItemVariation, enchantReader); We're going to use pre-generated enchant entries
                variation.property = RandomPropertiesBuilder.fill(variation.property, variation.enchants, builderItemVariation);
                variations.Add(variation);
                builderItemVariation++;
            }
        }

        private static uint calculatePropertyID(Item item, int builderItemVariation, int currentItemVariation)
        {
            return DBCHelper.getNextItemRandomPropertyEntry();
        }
    }
}
