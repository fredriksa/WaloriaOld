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

namespace SpellGenerator
{
    public partial class Application : Form
    {
        private int templateSpellID = 95001;
        private int itemStartID = 120000;

        public Application()
        {
            InitializeComponent();
        }

        private Dictionary<UInt32, Spell> spellDict = new Dictionary<UInt32, Spell>();
        private DBCReader reader = new DBCReader("Spell.dbc");
        private DBCHeader header = new DBCHeader();

        private void Application_Load_1(object sender, EventArgs e)
        {
            //Prepare header
            header.DBCmagic = DBCReader.DBCFmtSig;
            header.RecordsCount = (uint)reader.RecordsCount;
            header.FieldsCount = (uint)reader.FieldsCount;
            header.RecordSize = (uint)reader.RecordSize;
            header.StringTableSize = (uint)reader.StringTableSize;

            //Load individual spell structures
            for (int i = 0; i < header.RecordsCount; i++)
            {
                GCHandle handle = GCHandle.Alloc(reader.GetRowAsByteArray(i), GCHandleType.Pinned);
                var size = Marshal.SizeOf(typeof(Spell));
                Spell spell = (Spell)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(Spell));
                spellDict.Add(spell.Entry, spell);
                handle.Free();
            }

            //Prepare GUI
            entryField.Text = (spellDict.Keys.Max() + 1).ToString();

            //Delete output
            if (File.Exists("output.sql"))
                File.Delete("output.sql");

            var file = File.Create("output.sql");
            file.Close();
        }

        private void writeButton_Click(object sender, EventArgs e)
        {
            BinaryWriter writer = new BinaryWriter(File.Open("SpellDBC2.dbc", FileMode.Create));

            //Write header content
            writer.Write(DBCReader.DBCFmtSig);
            writer.Write(header.RecordsCount);
            writer.Write(header.FieldsCount);
            writer.Write(header.RecordSize);
            writer.Write(header.StringTableSize);

            //Write spell structures to file
            foreach (var pair in spellDict)
            {
                Spell spell = pair.Value;

                byte[] buffer = new byte[Marshal.SizeOf(typeof(Spell))];
                GCHandle handle = GCHandle.Alloc(buffer, GCHandleType.Pinned);
                Marshal.StructureToPtr(spell, handle.AddrOfPinnedObject(), true);
                writer.Write(buffer, 0, buffer.Length);
                handle.Free();
            }

            //Write string table
            foreach (var pair in reader.StringTable)
                writer.Write(Encoding.UTF8.GetBytes(pair.Value + "\0"));

            writer.Close();
        }

        private void addButton_Click(object sender, EventArgs e)
        {
            int entry = int.Parse(entryField.Text);
            int gameobject = int.Parse(gameobjectField.Text);

            entryField.Text = (entry + 1).ToString();

            Spell newSpell = spellDict[(uint)templateSpellID];
            newSpell.Entry = (uint)entry;
            newSpell.EffectMiscValue1 = gameobject;

            spellDict.Add(newSpell.Entry, newSpell);
            header.RecordsCount++;

            System.IO.StreamWriter file = new System.IO.StreamWriter("output.sql", true);

            string spellScriptQuery = String.Format("INSERT INTO spell_script_names VALUES ({0}, '{1}');", newSpell.Entry, "spell_building_system");
            file.WriteLine(spellScriptQuery);

            //item entry, name, spellentry
            int itemEntry = entry - templateSpellID + 120000;
            string itemName = "Spawn " + nameField.Text;
            string itemQuery = String.Format("INSERT INTO `item_template` (`entry`, `class`, `subclass`, `SoundOverrideSubclass`, `name`, `displayid`, `Quality`, `Flags`, `FlagsExtra`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `RequiredSkill`, `RequiredSkillRank`, `requiredspell`, `requiredhonorrank`, `RequiredCityRank`, `RequiredReputationFaction`, `RequiredReputationRank`, `maxcount`, `stackable`, `ContainerSlots`, `StatsCount`, `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`, `stat_type3`, `stat_value3`, `stat_type4`, `stat_value4`, `stat_type5`, `stat_value5`, `stat_type6`, `stat_value6`, `stat_type7`, `stat_value7`, `stat_type8`, `stat_value8`, `stat_type9`, `stat_value9`, `stat_type10`, `stat_value10`, `ScalingStatDistribution`, `ScalingStatValue`, `dmg_min1`, `dmg_max1`, `dmg_type1`, `dmg_min2`, `dmg_max2`, `dmg_type2`, `armor`, `holy_res`, `fire_res`, `nature_res`, `frost_res`, `shadow_res`, `arcane_res`, `delay`, `ammo_type`, `RangedModRange`, `spellid_1`, `spelltrigger_1`, `spellcharges_1`, `spellppmRate_1`, `spellcooldown_1`, `spellcategory_1`, `spellcategorycooldown_1`, `spellid_2`, `spelltrigger_2`, `spellcharges_2`, `spellppmRate_2`, `spellcooldown_2`, `spellcategory_2`, `spellcategorycooldown_2`, `spellid_3`, `spelltrigger_3`, `spellcharges_3`, `spellppmRate_3`, `spellcooldown_3`, `spellcategory_3`, `spellcategorycooldown_3`, `spellid_4`, `spelltrigger_4`, `spellcharges_4`, `spellppmRate_4`, `spellcooldown_4`, `spellcategory_4`, `spellcategorycooldown_4`, `spellid_5`, `spelltrigger_5`, `spellcharges_5`, `spellppmRate_5`, `spellcooldown_5`, `spellcategory_5`, `spellcategorycooldown_5`, `bonding`, `description`, `PageText`, `LanguageID`, `PageMaterial`, `startquest`, `lockid`, `Material`, `sheath`, `RandomProperty`, `RandomSuffix`, `block`, `itemset`, `MaxDurability`, `area`, `Map`, `BagFamily`, `TotemCategory`, `socketColor_1`, `socketContent_1`, `socketColor_2`, `socketContent_2`, `socketColor_3`, `socketContent_3`, `GemProperties`, `RequiredDisenchantSkill`, `ArmorDamageModifier`, `duration`, `ItemLimitCategory`, `HolidayId`, `ScriptName`, `DisenchantID`, `FoodType`, `minMoneyLoot`, `maxMoneyLoot`, `flagsCustom`, `VerifiedBuild`) VALUES ({0}, 0, 4, -1, '{1}', 26571, 1, 0, 0, 1, 0, 0, 0, -1, -1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {2}, 0, -1, -1, 1000, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, -1, 0, -1, 0, '', 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 12340);",
                                             itemEntry, itemName, newSpell.Entry);
            file.WriteLine(itemQuery);
            file.Flush();
            file.Close();
        }
    }
}
