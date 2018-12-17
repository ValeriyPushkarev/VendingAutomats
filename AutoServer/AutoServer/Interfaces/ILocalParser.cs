using System.Xml.Linq;

namespace AutoServer.Interfaces
{
    public interface ILocalParser
    {
        bool Parse(XElement input, string clientName);
    }
}
