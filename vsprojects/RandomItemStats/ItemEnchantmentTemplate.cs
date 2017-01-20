using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
using System.Windows.Forms;

namespace RandomItemStats
{
    class ItemEnchantmentTemplate
    {
        static string conString = DBHelper.getConString();
        static MySqlConnection con = new MySqlConnection();

        static ItemEnchantmentTemplate()
        {
            con.ConnectionString = conString;
            con.Open();
        }

        public static void add(Item item, List<ItemRandomProperties> properties)
        {
            try
            {
                string query = $"INSERT INTO item_enchantment_template VALUES ";

                foreach (ItemRandomProperties property in properties)
                {
                    query += $"({item.getDBRandomPropertyEntry()}, {property.ID}, {100 / properties.Count})";

                    if (properties.Last().ID != property.ID)
                        query += ",";
                    else
                        query += ";";
                }
                MySqlCommand delCmd = new MySqlCommand($"DELETE FROM item_enchantment_template WHERE entry={item.getDBRandomPropertyEntry()}", con);
                delCmd.ExecuteNonQuery();

                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                MessageBox.Show("ItemEnchantmentTemplate#add: " + e.Message);
            }
        }

        internal static void remove(Item item)
        {
            string conString = DBHelper.getConString();

            try
            {
                string query = $"DELETE FROM item_enchantment_template WHERE entry={item.getDBRandomPropertyEntry()};";
                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.ExecuteNonQuery();
            } catch (Exception ex)
            {
                MessageBox.Show("ItemEnchantmentTemplate#remove:" + ex.Message);
            }
        }
    }
}
