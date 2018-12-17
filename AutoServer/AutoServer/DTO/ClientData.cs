using System;

namespace AutoServer.DTO
{
    public class ClientData : IEquatable<ClientData>
    {
        string login;

        string address;

        public bool Equals(ClientData other)
        {
            if (other.login != login) return false;
            if (other.address != address) return false;

            return true;
        }
    }
}
