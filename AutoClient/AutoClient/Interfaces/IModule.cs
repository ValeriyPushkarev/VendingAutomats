using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace AutoClient.Interfaces
{
    interface IModule
    {
        void Start(IServerSocket socket);
        void Configure(XElement config);
    }
}
