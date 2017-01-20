using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class RandomPropertiesBuilder
    {
        public static ItemRandomProperties fill(ItemRandomProperties property, List<SpellItemEnchantment> enchants, int variationMod)
        {
            if (enchants.Count > 0)
                property.spellItemEnchantment1 = enchants[0].ID;

            if (enchants.Count > 1)
                property.spellItemEnchantment2 = enchants[1].ID;

            if (enchants.Count > 2)
                property.spellItemEnchantment3 = enchants[2].ID;

            property.suffix17 = 16712190;
            return property;
        }
    }
}
