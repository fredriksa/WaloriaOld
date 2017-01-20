using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class Budget
    {
        public static float calculate(Item item)
        {
            float budget = 0;

            foreach (StatPair pair in item.stats)
            {
                Stat stat = pair.stat;
                if (StatContainer.contains(stat.dbID))
                    budget += stat.cost * pair.value;
            }

            return budget;
        }
    }
}
