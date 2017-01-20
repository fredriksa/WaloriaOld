using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
using System.Windows.Forms;

namespace RandomItemStats
{
    class ItemUpdater
    {
        static string conString = DBHelper.getConString();

        public static void updateRandomProperty(Item item, int itemEnchantmentTableEntry)
        {
            try
            {
                MySqlConnection con = new MySqlConnection();
                con.ConnectionString = conString;
                con.Open();

                string query = $"UPDATE item_template SET RandomProperty={itemEnchantmentTableEntry} WHERE entry={item.entry};";
                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
            }
        }

        internal static void clearStats(Item item)
        {
            try
            {
                MySqlConnection con = new MySqlConnection();
                con.ConnectionString = conString;
                con.Open();

                int newStatsCount = (int)item.statsCount - item.stats.Count;
                string query = $"UPDATE item_template SET StatsCount={newStatsCount}";

                //Only sets the stat that we add as a random property to 0 in the DB
                foreach (StatPair pair in item.stats)
                {
                    if (item.stats.First() == pair)
                        query += ", ";

                  query += $"stat_type{pair.statDBID}=0, stat_value{pair.statDBID}=0";

                    if (item.stats.Last() != pair)
                        query += ",";
                }

                query += $" WHERE entry={item.entry}";

                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                MessageBox.Show("ITEM UPDATER: " + e.Message);
            }
        }
    }
}
