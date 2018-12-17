using AutoServer.DTO;
using AutoServer.Interfaces;
using System;
using System.Xml.Linq;

namespace AutoServer.services.parsers
{
    class PingParser : ILocalParser
    {
        private ICacher<PingData> _pingCacher;
        private object _lock;

        public PingParser(ICacher<PingData> pingCacher)
        {
            _pingCacher = pingCacher;
            _lock = new object();
        }

        public bool Parse(XElement input, string clientLogin)
        {
            if (!(input.Attribute("moduleType").Value == "ping"))
            {
                return false;
            }

            var data = new PingData
            {
                Date = DateTime.Now,
                Name = clientLogin
            };

            _pingCacher.Add(data);


            return true;
        }
    }
}
