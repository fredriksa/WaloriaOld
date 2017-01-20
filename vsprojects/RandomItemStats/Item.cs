using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class Item
    {
        public uint entry;
        public uint statsCount;

        public List<StatPair> stats = new List<StatPair>();

        public void clearStatValues()
        {
            foreach (StatPair statPair in stats)
            {
                if (StatContainer.contains(statPair.stat.dbID))
                    statPair.value = 0;
            }
        }

        public int getDBRandomPropertyEntry()
        {
            return (int)entry + 110000;
        } 
    }
}
