using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class StatContainer
    {
        public static Dictionary<int, Stat> stats = new Dictionary<int, Stat>();

        static StatContainer()
        {
            stats.Add(0, new Stat("NONE", 0, -1));
            stats.Add(3, new Stat("Agility", 1, 3));
            stats.Add(4, new Stat("Strength", 0.67f, 4));
            stats.Add(5, new Stat("Intellect", 1, 5));
            stats.Add(6, new Stat("Spirit", 1, 6));
            stats.Add(7, new Stat("Stamina", 1, 7));
            /*stats.Add(31, new Stat("Hit", 1.3f, 31));
            stats.Add(32, new Stat("Crit", 1.3f, 32));
            stats.Add(36, new Stat("Haste", 1.3f, 36));
            stats.Add(38, new Stat("Attackpower", 0.7f, 38));
            stats.Add(41, new Stat("Healing", 0.45f, 41));
            stats.Add(43, new Stat("Mana Per 5", 1.3f, 43));
            stats.Add(45, new Stat("Spellpower", 0.86f, 45));
            stats.Add(47, new Stat("Magic Penetration", 0.9f, 47));*/
        }

        public static Stat getFromDBID(int id) {
            if (contains(id)) //If we have a entry for the stat
            {
                return stats[id];
            }

            return null;
            /*else
            {
                return new Stat(id.ToString(), 0, id); //Else return dummy stat (shouldn't be edited).
            }*/
        }

        public static bool contains(int id)
        {
            return stats.Keys.Contains<int>(id);
        }
    }
}
