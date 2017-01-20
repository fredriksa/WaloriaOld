using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SpellGenerator
{
    public struct DBCHeader
    {
        public UInt32 DBCmagic;
        public UInt32 RecordsCount; //Records per file
        public UInt32 FieldsCount; //Fields per record
        public UInt32 RecordSize; 
        public UInt32 StringTableSize;
    }

    public struct DBCRow
    {
        public List<Byte> data;

        public DBCRow(byte[] data)
        {
            this.data = data.ToList();
        }
    }
}
