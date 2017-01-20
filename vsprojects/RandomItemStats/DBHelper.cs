using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data.MySqlClient;
using System.Windows.Forms;

namespace RandomItemStats
{   
    class DBHelper
    {
        //Returns a item from the DB
        public static Item fetchItem(uint entry)
        {
            return ItemFetcher.fetch(entry);
        }

        //Adds the enchants to item_enchantmen_template in the DB
        public static void addItemProperties(Item item, List<ItemRandomProperties> properties)
        {
            ItemEnchantmentTemplate.add(item, properties);
        }

        //Remove the items enchants in item_enchantment_template
        public static void removeItemEnchantments(Item item)
        {
            ItemEnchantmentTemplate.remove(item);
        }

        //Update a item's RandomProperty column in the DB
        public static void updateItemRandomProperty(Item item, int itemEnchantmentTableEntry)
        {
            ItemUpdater.updateRandomProperty(item, itemEnchantmentTableEntry);
        }

        //Update a items stat fields to 0
        public static void updateClearStats(Item item)
        {
            ItemUpdater.clearStats(item);
        }

        //Returns the connection string used for DB
        public static string getConString()
        {
            return $"SERVER=127.0.0.1;PORT=3306;DATABASE=world70;UID=root;PASSWORD=ascent";
        }
    }
}
