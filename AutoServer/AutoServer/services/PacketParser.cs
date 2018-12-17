using AutoServer.Interfaces;
using Microsoft.Practices.Unity;
using System.Collections.Generic;
using System.Xml.Linq;

namespace AutoServer.services
{
    class PacketParser : IPacketParser
    {
        private IUnityContainer _container;
        private IEnumerable<ILocalParser> _parsers;

        public PacketParser(IUnityContainer container)
        {
            _container = container;
            _parsers = _container.ResolveAll<ILocalParser>();
        }
        public void Parse(XElement Data, string clientName)
        {
            foreach (var parser in _parsers)
            {
                if (parser.Parse(Data, clientName)) break;
            }

        }
    }
}
