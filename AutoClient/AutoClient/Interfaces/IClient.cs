using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoClient.Interfaces
{

    public interface IClient
    {
        void Configure(string Host, int port, string login, string pass);

        void Start();

    }
}
