using AutoServer.DTO;

namespace AutoServer.Interfaces
{
    public interface IClientManager
    {
        void AddClient(ClientData data);

        void RemoveClient(ClientData data);

        ClientData[] GetClients();
    }
}
