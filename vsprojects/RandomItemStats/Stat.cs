using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{

    class Stat
    {
        public string name;
        public float cost;
        public int dbID;
        
        public Stat(string name, float cost, int dbID)
        {
            this.name = name;
            this.cost = cost;
            this.dbID = dbID;
        }

        public override int GetHashCode()
        {
            return dbID.GetHashCode();
        }

        public int spend(float budget)
        {
            return (int)Math.Ceiling(budget / cost);
        }
    }
}
