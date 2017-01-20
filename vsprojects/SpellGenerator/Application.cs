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
        public Application()
        {
            InitializeComponent();
        }

        private Dictionary<UInt32, Spell> spellDict = new Dictionary<UInt32, Spell>();
        private DBCReader reader = new DBCReader("Spell.dbc");
        private DBCHeader header = new DBCHeader();

        private void Application_Load(object sender, EventArgs e)
        {
            //Prepare GUI
            entryField.Text = "90050";
            effectBasePointMultiplierField.Text = "1.5";
            effectDieSidesMultiplierField.Text = "1.1";

            spellVariationField.Text = "15";

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

        private void loadButton_Click(object sender, EventArgs e)
        {
            UInt32 targetEntry = UInt32.Parse(entryField.Text);
            if (!spellDict.ContainsKey(targetEntry)) return;

            Spell targetSpell = spellDict[targetEntry];

            effectBasePoints1Field.Text = targetSpell.EffectBasePoints1.ToString();
            effectBasePoints2Field.Text = targetSpell.EffectBasePoints2.ToString();
            effectBasePoints3Field.Text = targetSpell.EffectBasePoints3.ToString();

            effectDieSides1Field.Text = targetSpell.EffectDieSides1.ToString();
            effectDieSides2Field.Text = targetSpell.EffectDieSides2.ToString();
            effectDieSides3Field.Text = targetSpell.EffectDieSides3.ToString();
        }

        private void generateButton_Click(object sender, EventArgs e)
        {
            int variations = int.Parse(spellVariationField.Text);

            UInt32 targetEntry = UInt32.Parse(entryField.Text);
            if (!spellDict.ContainsKey(targetEntry)) return;

            Spell targetSpell = spellDict[targetEntry];

            float effectBasePointMultiplier = float.Parse(effectBasePointMultiplierField.Text.Replace('.', ','));
            float effectDieSidesMultiplier = float.Parse(effectDieSidesMultiplierField.Text.Replace('.', ','));

            for (uint i = 1; i <= variations; i++)
            {
                Spell newSpell = targetSpell;

                newSpell.Entry += i;
                Console.WriteLine($"Target: {targetSpell.Entry} New: {newSpell.Entry}");

                newSpell.EffectBasePoints1 = int.Parse(effectBasePoints1Field.Text);
                newSpell.EffectBasePoints2 = int.Parse(effectBasePoints2Field.Text);
                newSpell.EffectBasePoints3 = int.Parse(effectBasePoints3Field.Text);

                newSpell.EffectDieSides1 = int.Parse(effectDieSides1Field.Text);
                newSpell.EffectDieSides2 = int.Parse(effectDieSides2Field.Text);
                newSpell.EffectDieSides3 = int.Parse(effectDieSides3Field.Text);

                newSpell.EffectBasePoints1 = (int)Math.Ceiling(newSpell.EffectBasePoints1 * effectBasePointMultiplier);
                newSpell.EffectBasePoints2 = (int)Math.Ceiling(newSpell.EffectBasePoints2 * effectBasePointMultiplier);
                newSpell.EffectBasePoints3 = (int)Math.Ceiling(newSpell.EffectBasePoints3 * effectBasePointMultiplier);

                newSpell.EffectDieSides1 = (int)Math.Ceiling(newSpell.EffectDieSides1 * effectBasePointMultiplier);
                newSpell.EffectDieSides2 = (int)Math.Ceiling(newSpell.EffectDieSides2 * effectBasePointMultiplier);
                newSpell.EffectDieSides3 = (int)Math.Ceiling(newSpell.EffectDieSides3 * effectBasePointMultiplier);

                spellDict.Add(newSpell.Entry, newSpell);
                header.RecordsCount++;
            }
        }

        private void readButton_Click(object sender, EventArgs e)
        {
            listBox1.Items.Add("######## HEADER ##########");

           listBox1.Items.Add($"RecordsCount: {header.RecordsCount}");
           listBox1.Items.Add($"FieldsCount: {header.FieldsCount}");
           listBox1.Items.Add($"RecordSize: {header.RecordSize}");
           listBox1.Items.Add($"StringTableSize: {header.StringTableSize}");
           listBox1.Items.Add($"RecordSize: {header.RecordSize } : {Marshal.SizeOf(new Spell())}");
           listBox1.Items.Add("########   END  ##########");


            foreach (var pair in spellDict)
            {
                Spell spell = pair.Value;
                listBox1.Items.Add($"{spell.Entry}, {reader.StringTable[(int)spell.SpellName_0]}, {reader.StringTable[(int)spell.Description_0]}");
            }
        }
    }
}
