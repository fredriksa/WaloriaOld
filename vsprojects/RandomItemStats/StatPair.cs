using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class StatPair : ICloneable<StatPair>
    {
        public Stat stat;
        public int value;
        public int statDBID;

        public StatPair(Stat stat, int value, int statDBID)
        {
            this.stat = stat;
            this.value = value;
            this.statDBID = statDBID; //If it's stat_type1/value1 combo etc.
        }

        public override string ToString()
        {
            return "+" + value.ToString() + " " + stat.name;
        }

        public StatPair Clone()
        {
            return new StatPair(new Stat(stat.name, stat.cost, stat.dbID), value, statDBID);
        }
    }

    internal interface ICloneable<T>
    {
        T Clone();
    }
}
