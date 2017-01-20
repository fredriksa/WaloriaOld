using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MySql.Data.MySqlClient;

namespace RandomItemStats
{
    class ItemFetcher
    {
        public static Item fetch(uint entry)
        {
            string conString = DBHelper.getConString();

            try
            {
                MySqlConnection con = new MySqlConnection();
                con.ConnectionString = conString;
                con.Open();

                string query = $"SELECT * FROM item_template WHERE entry={entry};";
                MySqlCommand cmd = new MySqlCommand(query, con);
                MySqlDataReader reader = cmd.ExecuteReader();

                reader.Read();

                Item item = new Item();

                item.entry = uint.Parse(reader["entry"].ToString());
                item.statsCount = uint.Parse(reader["statscount"].ToString());

                Stat stat;
                int value;

                stat = StatContainer.getFromDBID(int.Parse(reader["stat_Type1"].ToString()));
                value = int.Parse(reader["stat_Value1"].ToString());
                if (value > 0 && StatContainer.contains(int.Parse(reader["stat_Type1"].ToString())))
                    item.stats.Add(new StatPair(stat, value, 1));

                stat = StatContainer.getFromDBID(int.Parse(reader["stat_Type2"].ToString()));
                value = int.Parse(reader["stat_Value2"].ToString());
                if (value > 0 && StatContainer.contains(int.Parse(reader["stat_Type2"].ToString()))) 
                    item.stats.Add(new StatPair(stat, value, 2));

                stat = StatContainer.getFromDBID(int.Parse(reader["stat_Type3"].ToString()));
                value = int.Parse(reader["stat_Value3"].ToString());
                if (value > 0 && StatContainer.contains(int.Parse(reader["stat_Type3"].ToString())))
                    item.stats.Add(new StatPair(stat, value, 3));

                con.Close();
                return item;

            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
            }

            return null;
        }
    }
}
