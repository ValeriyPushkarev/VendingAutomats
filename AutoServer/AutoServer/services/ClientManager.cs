using AutoServer.DTO;
using AutoServer.Interfaces;
using System.Collections.Generic;
using System.Linq;

namespace AutoServer.services
{
    class ClientManager : IClientManager
    {
        private List<ClientData> Clients;
        private object _lock;

        public ClientManager()
        {
            _lock = new object();
        }

        public void AddClient(ClientData data)
        {
            lock (_lock)
            {
                if (!(Clients.Any((t) => t.Equals(data))))
                    Clients.Add(data);
            }
        }

        public void RemoveClient(ClientData data)
        {
            lock (_lock)
            {
                if (!(Clients.Any((t) => t.Equals(data))))
                    Clients.Remove(data);
            }
        }

        public ClientData[] GetClients()
        {
            lock (_lock)
            {
                return Clients.ToArray();
            }
        }
    }
}
