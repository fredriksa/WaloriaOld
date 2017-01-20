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

namespace SpellGenerator
{
    public partial class Application : Form
    {
        public Application()
        {
            InitializeComponent();
        }

        private Dictionary<UInt32, Spell> spellDict = new Dictionary<UInt32, Spell>();
        private Dictionary<UInt32, SkillLine> skillLineDict = new Dictionary<UInt32, SkillLine>();
        private Dictionary<UInt32, SkillLineAbility> skillLineAbilityDict = new Dictionary<UInt32, SkillLineAbility>();

        private DBCReader spellReader = new DBCReader("Spell.dbc");
        private DBCHeader spellHeader = new DBCHeader();

        private DBCReader skillLineReader = new DBCReader("SkillLine.dbc");
        private DBCHeader skillLineHeader = new DBCHeader();

        private DBCReader skillLineAbilityReader = new DBCReader("SkillLineAbility.dbc");
        private DBCHeader skillLineAbilityHeader = new DBCHeader();

        private void Application_Load(object sender, EventArgs e)
        {
            //Prepare GUI
            powerTypeCombo.Items.Add(new ComboItem("Mana", (int)PowerType.MANA));
            powerTypeCombo.Items.Add(new ComboItem("Rage", (int)PowerType.RAGE));
            powerTypeCombo.Items.Add(new ComboItem("Energy", (int)PowerType.ENERGY));
            powerTypeCombo.SelectedIndex = 0;

            //Prepare spellHeader
            spellHeader.DBCmagic = DBCReader.DBCFmtSig;
            spellHeader.RecordsCount = (uint)spellReader.RecordsCount;
            spellHeader.FieldsCount = (uint)spellReader.FieldsCount;
            spellHeader.RecordSize = (uint)spellReader.RecordSize;
            spellHeader.StringTableSize = (uint)spellReader.StringTableSize;

            //Load individual spell structures
            for (int i = 0; i < spellHeader.RecordsCount; i++)
            {
                GCHandle handle = GCHandle.Alloc(spellReader.GetRowAsByteArray(i), GCHandleType.Pinned);
                var size = Marshal.SizeOf(typeof(Spell));
                Spell spell = (Spell)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(Spell));
                spellDict.Add(spell.Entry, spell);
                handle.Free();
            }

            //Prepare skillLineHeader
            skillLineHeader.DBCmagic = DBCReader.DBCFmtSig;
            skillLineHeader.RecordsCount = (uint)skillLineReader.RecordsCount;
            skillLineHeader.FieldsCount = (uint)skillLineReader.FieldsCount;
            skillLineHeader.RecordSize = (uint)skillLineReader.RecordSize;
            skillLineHeader.StringTableSize = (uint)skillLineReader.StringTableSize;

            //Load individual skill line ability structures
            for (int i = 0; i < skillLineHeader.RecordsCount; i++)
            {
                GCHandle handle = GCHandle.Alloc(skillLineReader.GetRowAsByteArray(i), GCHandleType.Pinned);
                var size = Marshal.SizeOf(typeof(SkillLine));
                SkillLine skillLine = (SkillLine)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(SkillLine));
                skillLineDict.Add(skillLine.ID, skillLine);
                handle.Free();
            }

            skillLineAbilityHeader.DBCmagic = DBCReader.DBCFmtSig;
            skillLineAbilityHeader.RecordsCount = (uint)skillLineAbilityReader.RecordsCount;
            skillLineAbilityHeader.FieldsCount = (uint)skillLineAbilityReader.FieldsCount;
            skillLineAbilityHeader.RecordSize = (uint)skillLineAbilityReader.RecordSize;
            skillLineAbilityHeader.StringTableSize = (uint)skillLineAbilityReader.StringTableSize;

            //Load individual skill line ability structures
            for (int i = 0; i < skillLineAbilityHeader.RecordsCount; i++)
            {
                GCHandle handle = GCHandle.Alloc(skillLineAbilityReader.GetRowAsByteArray(i), GCHandleType.Pinned);
                var size = Marshal.SizeOf(typeof(SkillLineAbility));
                SkillLineAbility skillLineAbility = (SkillLineAbility)Marshal.PtrToStructure(handle.AddrOfPinnedObject(), typeof(SkillLineAbility));
                skillLineAbilityDict.Add(skillLineAbility.ID, skillLineAbility);
                handle.Free();
            }
        }

        private void writeButton_Click(object sender, EventArgs e)
        {
            BinaryWriter writer = new BinaryWriter(File.Open("Spell2.dbc", FileMode.Create));

            //Write spellHeader content
            writer.Write(DBCReader.DBCFmtSig);
            writer.Write(spellHeader.RecordsCount);
            writer.Write(spellHeader.FieldsCount);
            writer.Write(spellHeader.RecordSize);
            writer.Write(spellHeader.StringTableSize);

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
            foreach (var pair in spellReader.StringTable)
                writer.Write(Encoding.UTF8.GetBytes(pair.Value + "\0"));

            writer.Close();
        }

        private void readButton_Click(object sender, EventArgs e)
        {
            // Fill spells

            bool addHeaderInfo = false;

            if (addHeaderInfo)
            {
                listBox1.Items.Add("######## HEADER ##########");
                listBox1.Items.Add($"RecordsCount: {spellHeader.RecordsCount}");
                listBox1.Items.Add($"FieldsCount: {spellHeader.FieldsCount}");
                listBox1.Items.Add($"RecordSize: {spellHeader.RecordSize}");
                listBox1.Items.Add($"StringTableSize: {spellHeader.StringTableSize}");
                listBox1.Items.Add($"RecordSize: {spellHeader.RecordSize } : {Marshal.SizeOf(new Spell())}");
                listBox1.Items.Add("########   END  ##########");
            }

            //Fill list boxes
            foreach (var pair in spellDict)
            {
                Spell spell = pair.Value;
                listBox1.Items.Add($"{spell.Entry}, {spellReader.StringTable[(int)spell.SpellName_0]}, {spellReader.StringTable[(int)spell.Description_0]}");
            }

            skillLineList.Items.Add(new SkillLineItem("Mana lines", new List<int> {6, 8, 237, 355, 354, 593, 574,
                                                                                    573, 375, 373, 374, 78, 56, 613,
                                                                                    50, 163, 51, 594, 267, 184}));

            skillLineList.Items.Add(new SkillLineItem("Rage lines", new List<int> { 26, 256, 257 }));

            skillLineList.Items.Add(new SkillLineItem("Energy Lines", new List<int> { 39, 38, 253, 134 }));
            //skillLineOptions.Add(new { Text = $"{skillLine.ID}, {skillLineReader.StringTable[(int)skillLine.sRefName0]}", Value = skillLine.ID});
            skillLineList.SelectedIndex = 0;
        }

        private void loadSpellsButton_Click(object sender, EventArgs e)
        {
            SkillLineItem skillLineItem = (SkillLineItem)skillLineList.SelectedItem;
            MySqlConnection con = new MySqlConnection();
            string conString = "SERVER=127.0.0.1;PORT=3306;DATABASE=world70;UID=root;PASSWORD=ascent;"; 
            con.ConnectionString = conString;
            con.Open();

            foreach (var skillLineID in skillLineItem.skillLines)
            {
                foreach (var pair in skillLineAbilityDict)
                {
                    SkillLineAbility skillLineAbility = pair.Value;
                    if (skillLineID != skillLineAbility.skillLine) continue;
                    if (skillLineAbility.skillLine != skillLineID) continue;

                    /* Spells which we should modify */
                    if (!spellDict.Keys.Contains(skillLineAbility.spell)) continue;
                    Spell spell = spellDict[skillLineAbility.spell];

                    //Filtering out obsolete spells
                    //if (spell.StartRecoveryCategory == 0 || spell.StartRecoveryTime == 0
                    //  || spell.baseLevel == 0) continue;

                    if (spell.baseLevel == 0) continue;

                    try
                    {
                        string query = $"INSERT INTO custom_spell_system (spellID, spellName, spellLevel)VALUES ({spell.Entry},\"{spellReader.StringTable[(int)spell.SpellName_0]}\", {spell.spellLevel});";
                        //MessageBox.Show(query);
                        MySqlCommand cmd = new MySqlCommand(query, con);
                        MySqlDataReader reader = cmd.ExecuteReader();
                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }

                    combinedSpellList.Items.Add($"{spell.Entry}, {spellReader.StringTable[(int)spell.SpellName_0]}, {spellReader.StringTable[(int)spell.Description_0]}");
                }
            }
        }

        private void updateSkillLineAbilitiesButton_Click(object sender, EventArgs e)
        {
            ComboItem item = (ComboItem)powerTypeCombo.SelectedItem;

            switch (item.value)
            {
                case (int)PowerType.MANA:
                    handleManaLine();
                    break;
                case (int)PowerType.RAGE:
                    handleRageLine();
                    break;
                case (int)PowerType.ENERGY:
                    handleEnergyLine();
                    break; 
            }
        }


        //20 rage = 200 powercost (manaCost in DB files)
        //20 energy = 20 powercost (manaCost in DB files)
        private void handleManaLine()
        {
            SkillLineItem skillLineItem = (SkillLineItem)skillLineList.SelectedItem;

            foreach (var skillLineID in skillLineItem.skillLines)
            {
                foreach (var pair in skillLineAbilityDict)
                {
                    SkillLineAbility skillLineAbility = pair.Value;
                    if (skillLineID != skillLineAbility.skillLine) continue;
                    if (skillLineAbility.skillLine != skillLineID) continue;

                    /* Spells which we should modify */
                    if (!spellDict.Keys.Contains(skillLineAbility.spell)) continue;
                    Spell spell = spellDict[skillLineAbility.spell];
                    //if (spell.Entry != 116) continue;

                    //So we don't edit spells which have already been converted or use the energy resource
                    if (spell.powerType != (uint)PowerType.MANA) continue;
                    spell.powerType = (uint)PowerType.ENERGY;

                    //Let's say a frostbolt costs 11, now it costs 33, if it's above 75 it will become 75.
                    uint baseEnergyCost = spell.ManaCostPercentage;
                    baseEnergyCost *= 3;
                    if (baseEnergyCost > 75) baseEnergyCost = 75;

                    spell.manaCost = baseEnergyCost; //manaCost is Power Cost in spell editor, 20 energy = 
                    spell.ManaCostPercentage = 0;

                    spellDict[skillLineAbility.spell] = spell;
                }
            }
        }

        private void handleRageLine()
        {
            SkillLineItem skillLineItem = (SkillLineItem)skillLineList.SelectedItem;

            foreach (var skillLineID in skillLineItem.skillLines)
            {
                foreach (var pair in skillLineAbilityDict)
                {
                    SkillLineAbility skillLineAbility = pair.Value;
                    if (skillLineID != skillLineAbility.skillLine) continue;
                    if (skillLineAbility.skillLine != skillLineID) continue;

                    /* Spells which we should modify */
                    if (!spellDict.Keys.Contains(skillLineAbility.spell)) continue;
                    Spell spell = spellDict[skillLineAbility.spell];
                    //if (spell.Entry != 116) continue;

                    //So we don't edit spells which have already been converted or use the energy resource
                    if (spell.powerType != (uint)PowerType.RAGE) continue;
                    spell.powerType = (uint)PowerType.ENERGY;

                    //Let's say a frostbolt costs 11, now it costs 33, if it's above 75 it will become 75.
                    uint baseEnergyCost = spell.manaCost / 10;
                    baseEnergyCost *= 2;
                    spell.manaCost = baseEnergyCost; //manaCost is Power Cost in spell editor, 20 energy = 
                    spell.ManaCostPercentage = 0;

                    spellDict[skillLineAbility.spell] = spell;
                }
            }
        }

        private void handleEnergyLine()
        {

        }
    }
}
