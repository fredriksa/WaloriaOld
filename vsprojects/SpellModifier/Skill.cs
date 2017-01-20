using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace SpellGenerator
{
    public struct SkillLine
    {
        public uint ID;
        public uint iRefID_SkillLineCategory;
        public uint skillCostID;
        public uint sRefName0;
        public uint sRefName1;
        public uint sRefName2;
        public uint sRefName3;
        public uint sRefName4;
        public uint sRefName5;
        public uint sRefName6;
        public uint sRefName7;
        public uint sRefName8;
        public uint sRefName9;
        public uint sRefName10;
        public uint sRefName11;
        public uint sRefName12;
        public uint sRefName13;
        public uint sRefName14;
        public uint sRefName15;
        public uint description0;
        public uint description1;
        public uint description2;
        public uint description3;
        public uint description4;
        public uint description5;
        public uint description6;
        public uint description7;
        public uint description8;
        public uint description9;
        public uint description10;
        public uint description11;
        public uint description12;
        public uint description13;
        public uint description14;
        public uint description15;
        public uint spellIconID;
        public uint verb0;
        public uint verb1;
        public uint verb2;
        public uint verb3;
        public uint verb4;
        public uint verb5;
        public uint verb6;
        public uint verb7;
        public uint verb8;
        public uint verb9;
        public uint verb10;
        public uint verb11;
        public uint verb12;
        public uint verb13;
        public uint verb14;
        public uint verb15;
        public uint canLink;
    };

    public struct SkillLineAbility
    {
        public uint ID;
        public uint skillLine;
        public uint spell;
        public uint chrRaces;
        public uint chrClasses;
        public uint chrRaces2;
        public uint chrClasses2;
        public uint reqSkillValue;
        public uint spellDBCParent;
        public uint acquireMethod;
        public uint skillGreyLevel;
        public uint skillYellowLevel;
        public uint characterPoints1;
        public uint characterPoints2;
    };
}
