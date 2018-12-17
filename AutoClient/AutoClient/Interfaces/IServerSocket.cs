using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoClient.Interfaces
{
    public delegate void ServerSend(object Data);
    
    public interface IServerSocket
    {
        string Name { get; }
        string Type { get; }
        void Send(object data);
        event ServerSend Receive;
    }
}
