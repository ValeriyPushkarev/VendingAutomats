using AutoServer.Interfaces;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoServer.services
{
    class StreamParser : IStreamParser
    {
        private List<byte> _data = new List<byte>();

        private byte[] _begin = UTF8Encoding.UTF8.GetBytes("<packet");
        private byte[] _end = UTF8Encoding.UTF8.GetBytes("</packet>");

        public void Add(byte[] data)
        {
            _data.AddRange(data);
        }

        public bool HasNext()
        {
            var first = PositionOfSeq(_data, _begin);
            var second = PositionOfSeq(_data, _end, first>0?first:0);

            if ((first >= 0) && (second >= 0)) 
                return true;

            return false;
        }

        private int PositionOfSeq(List<byte> source, byte[] pattern, int from = 0)
        {
            var pos_curr = -1;
            var pos_patt = 0;

            var len = source.Count();
            var len_patt = pattern.Length;

            for (int pos = from; pos < len; pos++)
            {
                if (source[pos] == pattern[pos_patt])
                {
                    if (pos_patt == 0) pos_curr = pos;
                    pos_patt++;
                }
                else
                {
                    pos_curr = -1;
                    pos_patt = 0;
                }

                if (pos_patt >= len_patt)
                    return pos_curr;
                
            }

            return -1;
        }

        public string GetNext()
        {
            var first = PositionOfSeq(_data, _begin);
            var second = PositionOfSeq(_data, _end, first>0?first:0);

            var result = "";

            if ((first >= 0) && (second > 0))
            {
                result = UTF8Encoding.UTF8.GetString(_data.ToArray().Skip(first).Take(second + _end.Length - first).ToArray());
                _data.RemoveRange(0, second + _end.Length);
            }
           
            return result;
        }
    }
}
