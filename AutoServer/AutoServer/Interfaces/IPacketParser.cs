using System.Xml.Linq;

namespace AutoServer.Interfaces
{
    public interface IPacketParser
    {
        void Parse(XElement Data, string clientLogin = "");
    }
}
