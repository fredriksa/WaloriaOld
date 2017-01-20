using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
using System.Windows.Forms;

namespace RandomItemStats
{
    class RandomItemStatsGenerator
    {

        private Form1 form;
        private string conString = DBHelper.getConString();

        public RandomItemStatsGenerator(Form1 form) { this.form = form; }

        public void generate()
        {

            MySqlConnection con = new MySqlConnection();
            con.ConnectionString = conString;
            con.Open();

            string query = $"SELECT entry, StatsCount, stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, RandomProperty FROM item_template WHERE class IN (2,4);";
            MySqlCommand cmd = new MySqlCommand(query, con);
            cmd.CommandTimeout = int.MaxValue;
            MySqlDataReader reader = cmd.ExecuteReader();

            List<string> itemTemplateData = new List<string>();

            while (reader.Read()) //Now reads data correctly
            {
                string dataStr = string.Empty;
                dataStr += reader["entry"].ToString() + ",";
                dataStr += reader["StatsCount"].ToString() + ",";
                dataStr += reader["stat_type1"].ToString() + ",";
                dataStr += reader["stat_value1"].ToString() + ",";
                dataStr += reader["stat_type2"].ToString() + ",";
                dataStr += reader["stat_value2"].ToString() + ",";
                dataStr += reader["stat_type3"].ToString() + ",";
                dataStr += reader["stat_value3"].ToString() + ",";
                dataStr += reader["RandomProperty"].ToString() + "";

                itemTemplateData.Add(dataStr);
            }

            int currentItemVariation = 1; //The index of the item that we're currently generating
            foreach (string data in itemTemplateData)
            {
                string[] splitData = data.Split(',');
                uint entry = uint.Parse(splitData[0]);
                Console.WriteLine(entry);
                generateFromItemEntry(entry, currentItemVariation);
                currentItemVariation++;
            }
            //generateFromItemEntry(itemEntry); //fault is inside here

            reader.Close();
            con.Close();
        }

        public void generateFromItemEntry(uint entry, int currentItemVariation)
        {
            Item selectedItem = DBHelper.fetchItem(entry);

            if (selectedItem == null || selectedItem.statsCount <= 1) return;

            List<Item> itemVariations = new List<Item>();
            itemVariations.Add(selectedItem);

            List<Variation> variations = new List<Variation>();
            for (int i = 0; i < Form1.nVariations-1; i++)
                itemVariations.Add(VariationGenerator.generate(selectedItem));

            //Create variations
            VariationBuilder.fill(variations, itemVariations, form.enchantReader, currentItemVariation);

            //Update item's RanmdomProperty to item_enchantment_template entry
            DBHelper.updateItemRandomProperty(selectedItem, selectedItem.getDBRandomPropertyEntry());

            //Remove stats for the item in the DB
            DBHelper.updateClearStats(selectedItem);
 
            //Add enchants to DB
            DBHelper.removeItemEnchantments(selectedItem);
            List<ItemRandomProperties> properties = new List<ItemRandomProperties>();
            variations.ForEach(x => properties.Add(x.property));
            DBHelper.addItemProperties(selectedItem, properties);

            //Merge with existing dicts
            foreach (Variation variation in variations)
            {
                //foreach (SpellItemEnchantment enchant in variation.enchants) We're going to pre-generate entries to pick from
                //   form.enchantDict.Add(enchant.ID, enchant);

                form.randomPropertiesDict.Add(variation.property.ID, variation.property);
            }
        }
    }
}
