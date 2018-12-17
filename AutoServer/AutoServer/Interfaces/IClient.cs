using System.Net.Sockets;

namespace AutoServer.Interfaces
{
    public interface IClient
    {
        void Start(TcpClient tcpClient);
    }
}
