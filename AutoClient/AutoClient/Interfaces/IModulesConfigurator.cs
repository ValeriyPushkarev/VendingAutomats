using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoClient.Interfaces
{
    interface IModulesConfigurator
    {
        void Configure(string clientName, Queue<IServerSocket> sockets, ConcurrentQueue<string> messages);
    }
}
