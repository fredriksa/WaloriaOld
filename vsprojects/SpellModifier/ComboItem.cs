using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpellGenerator
{
    class ComboItem
    {
        public string text;
        public int value;

        public ComboItem(string text, int value) { this.text = text; this.value = value; }
        public override string ToString() { return text;  }
    }
}
