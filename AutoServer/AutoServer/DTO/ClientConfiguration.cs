using AutoServer.Interfaces;
using System.Net.Sockets;

namespace AutoServer.DTO
{
    public class ClientConfiguration
    {
        public TcpClient tcpClient { get; set; }
        public IClientManager clientManager { get; set; }
        public IPacketParser packetParser { get; set; }
        public IStreamParser streamParser { get; set; }
    }
}
