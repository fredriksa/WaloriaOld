using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

namespace RandomItemStats
{
    class DBCHelper
    {
        private static uint nextEnchantEntry = 5000;
        private static uint nextItemRandomPropertyEntry = 5000;

        public static DBCHeader prepareHeader(DBCReader reader)
        {
            DBCHeader header = new DBCHeader();

            header.DBCmagic = DBCReader.DBCFmtSig;
            header.RecordsCount = (uint)reader.RecordsCount;
            header.FieldsCount = (uint)reader.FieldsCount;
            header.RecordSize = (uint)reader.RecordSize;
            header.StringTableSize = (uint)reader.StringTableSize;

            return header;
        }

        public static uint getNextEnchantEntry()
        {
            uint entry = nextEnchantEntry;
            nextEnchantEntry++;
            return entry;
        }

        public static uint getNextItemRandomPropertyEntry()
        {
            uint entry = nextItemRandomPropertyEntry;
            nextItemRandomPropertyEntry++;
            return entry;
        }

    }
}
