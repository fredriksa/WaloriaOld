using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class EnchantContainer
    {
        public static Dictionary<int, List<SpellItemEnchantment>> enchants = new Dictionary<int, List<SpellItemEnchantment>>();
        
        /*
            So if we want enchantment for +3 Agility we pass in: enchants[Stat(agility)][3]
        */
        public static SpellItemEnchantment get(StatPair pair)
        {
            return enchants[pair.stat.dbID][pair.value];
        }
    }
}
