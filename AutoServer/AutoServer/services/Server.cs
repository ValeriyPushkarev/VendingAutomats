using AutoServer.Interfaces;
using System.Net.Sockets;
using Microsoft.Practices.Unity;

namespace AutoServer.services
{
    class Server : IServer
    {
        private TcpListener _server;
        private IUnityContainer _container;

        public Server(IUnityContainer container)
        {
            _container = container;
        }
        public void Start(int port)
        {
            _server = new TcpListener(port);
            _server.Start();
            WaitClients();
        }

        private void WaitClients()
        {
            while (true)
            {
                var clientSocket = _server.AcceptTcpClient();


                var client = _container.Resolve<IClient>();

                client.Start(clientSocket);
            }
        }

        public void Stop()
        {
            _server.Stop();
        }
    }
}
