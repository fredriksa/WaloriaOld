using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpellGenerator
{
    class SkillLineItem
    {
        public string name;
        public List<int> skillLines;

        public SkillLineItem(string name, List<int> skillLines)
        {
            this.name = name;
            this.skillLines = skillLines;
        }

        public override string ToString() { return name;  }
    }
}
