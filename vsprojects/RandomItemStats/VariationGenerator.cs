using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RandomItemStats
{
    class VariationGenerator
    {
        const int iterations = 15; //The higher the better(more even) random distribution

        public static Item generate(Item baseItem)
        {
            Item variation = new Item();

            variation.statsCount = baseItem.statsCount;
            variation.entry = baseItem.entry;

            List<StatPair> clonedList = new List<StatPair>();
            foreach(StatPair statPair in baseItem.stats)
                clonedList.Add(statPair.Clone());

            variation.stats = clonedList;

            float statBudget = Budget.calculate(baseItem);
            List<float> statBudgetList = distributeBudget(variation, statBudget);
            spendBudget(variation, statBudgetList);

            return variation;
        }

        private static List<float> distributeBudget(Item item, float statBudget)
        {
            List<float> statBudgetList = new List<float>();

            float itBudget = statBudget / iterations;

            for (int i=0; i < iterations; i++)
            {
                Random rnd = new Random(Guid.NewGuid().GetHashCode());
                int statIndex = rnd.Next(0, item.stats.Count);

                if (statBudgetList.ElementAtOrDefault(statIndex) == 0)
                {
                    statBudgetList.Add(itBudget);
                } else
                {
                    statBudgetList[statIndex] += itBudget;
                }
            }

            return statBudgetList;
        }

        private static void spendBudget(Item item, List<float> statBudgetList)
        {
            //Set the amount of stats for every stat to 0
            item.clearStatValues();

            //Purchase new stats
            for (int i = 0; i < statBudgetList.Count; i++)
                if (item.stats.Count > i)
                    item.stats[i].value = item.stats[i].stat.spend(statBudgetList[i]);
        }
    }
}
