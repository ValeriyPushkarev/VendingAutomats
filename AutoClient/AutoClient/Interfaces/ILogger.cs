using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoClient.Interfaces
{
    public interface ILogger
    {
        void LogSocket(IServerSocket socket, string message);
        void Log(string name, string shortDesc, string message);
    }
}
