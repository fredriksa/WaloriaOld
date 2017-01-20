using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Runtime.InteropServices;
using MySql.Data.MySqlClient;

namespace RandomItemStats
{
    //Client only accepts uint16's as itemenchantments so we must
    //Have enchantment ids within that range
    partial class Form1 : Form
    {
        public static int nVariations = 12; //nVariations = total variations

        public Form1()
        {
            InitializeComponent();
        }

        public Dictionary<UInt32, SpellItemEnchantment> enchantDict = new Dictionary<UInt32, SpellItemEnchantment>();
        public Dictionary<UInt32, ItemRandomProperties> randomPropertiesDict = new Dictionary<UInt32, ItemRandomProperties>();

        public DBCReader enchantReader = new DBCReader("SpellItemEnchantment.dbc");
        public DBCHeader enchantHeader = new DBCHeader();

        public DBCReader randomPropertiesReader = new DBCReader("ItemRandomProperties.dbc");
        public DBCHeader randomPropertiesHeader = new DBCHeader();

        public List<Variation> variations = new List<Variation>();

        public Item selectedItem;

        private void Form1_Load(object sender, EventArgs e)
        {
            //Prepare header
            enchantHeader = DBCHelper.prepareHeader(enchantReader);

            //Load individual enchanments
            for (int i = 0; i < enchantHeader.RecordsCount; i++)
            {
                GCHandle handle = GCHandle.Alloc(enchantReader.GetRowAsByteArray(i), GCHandleType.Pinned);
                var size = Marshal.SizeOf(typeof(SpellItemEnchantment));
                SpellItemEnchantment enchantment = (SpellItemEnchantment)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(SpellItemEnchantment));
                enchantDict.Add(enchantment.ID, enchantment);
                handle.Free();
            }

            //Prepare header
            randomPropertiesHeader = DBCHelper.prepareHeader(randomPropertiesReader);

            //Load individual enchanments
            for (int i = 0; i < randomPropertiesHeader.RecordsCount; i++)
            {
                GCHandle handle = GCHandle.Alloc(randomPropertiesReader.GetRowAsByteArray(i), GCHandleType.Pinned);
                var size = Marshal.SizeOf(typeof(ItemRandomProperties));
                ItemRandomProperties randomProperties = (ItemRandomProperties)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(ItemRandomProperties));
                randomPropertiesDict.Add(randomProperties.ID, randomProperties);
                handle.Free();
            }

            this.Text = this.Text + " " + enchantDict.Keys.Count.ToString() + " enchants " + randomPropertiesDict.Keys.Count.ToString() + " properties";
            itemEntryField.Text = "16913";
        }

        private void loadItemButton_Click(object sender, EventArgs e)
        {
            selectedItem = DBHelper.fetchItem(uint.Parse(itemEntryField.Text));
            beforeTextBox.Text = selectedItem.ToString();
        }

        private void variationButton_Click(object sender, EventArgs e)
        {
            EnchantPopulator.populate(enchantReader).ForEach(x => enchantDict.Add(x.ID, x));
            RandomItemStatsGenerator generator = new RandomItemStatsGenerator(this);
            generator.generate();
            Console.WriteLine("");
        }

        private void saveButton_Click(object sender, EventArgs e)
        {
            saveToDBC();
        }

        private void saveToDBC()
        {
            BinaryWriter writer = new BinaryWriter(File.Open("ItemRandomProperties2.dbc", FileMode.Create));

            writer.Write(DBCReader.DBCFmtSig);
            writer.Write((uint)randomPropertiesDict.Values.Count);
            writer.Write((uint)randomPropertiesReader.FieldsCount);
            writer.Write((uint)randomPropertiesReader.RecordSize);
            writer.Write((uint)randomPropertiesReader.StringTableSize);

            foreach (ItemRandomProperties property in randomPropertiesDict.Values.ToList())
            {
                byte[] buffer = new byte[Marshal.SizeOf(typeof(ItemRandomProperties))];
                GCHandle handle = GCHandle.Alloc(buffer, GCHandleType.Pinned);
                Marshal.StructureToPtr(property, handle.AddrOfPinnedObject(), true);
                writer.Write(buffer, 0, buffer.Length);
                handle.Free();
            }

            foreach (var pair in randomPropertiesReader.StringTable)
                writer.Write(Encoding.UTF8.GetBytes(pair.Value + "\0"));

            writer.Close();

            BinaryWriter writer2 = new BinaryWriter(File.Open("SpellItemEnchantment2.dbc", FileMode.Create));

            writer2.Write(DBCReader.DBCFmtSig);
            writer2.Write((uint)enchantDict.Values.Count);
            writer2.Write((uint)enchantReader.FieldsCount);
            writer2.Write((uint)enchantReader.RecordSize);
            writer2.Write((uint)enchantReader.StringTableSize);

            foreach (SpellItemEnchantment enchant in enchantDict.Values.ToList())
            {
                byte[] buffer = new byte[Marshal.SizeOf(typeof(SpellItemEnchantment))];
                GCHandle handle = GCHandle.Alloc(buffer, GCHandleType.Pinned);
                Marshal.StructureToPtr(enchant, handle.AddrOfPinnedObject(), true);
                writer2.Write(buffer, 0, buffer.Length);
                handle.Free();
            }

            foreach (var pair in enchantReader.StringTable)
                writer2.Write(Encoding.UTF8.GetBytes(pair.Value + "\0"));

            writer2.Close();

            MessageBox.Show("SAVED");
        }
    }
}
