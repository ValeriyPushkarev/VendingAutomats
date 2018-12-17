using AutoClient.Interfaces;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace AutoClient.Services.Modules
{
    public class ConfigurationInfo:IModule
    {
        public void Start(IServerSocket socket)
        {
            var conf = File.ReadAllText("modules.conf");
            socket.Send(conf);
        }

        public void Configure(XElement config)
        {
            
        }
    }
}
