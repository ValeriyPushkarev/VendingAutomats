using AutoClient.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace AutoClient.Services.Modules
{
    public class PingModule:IModule
    {
        private IServerSocket _socket;
        private ILogger _logger;

        public PingModule(ILogger logger)
        {
            _logger = logger;
        }

        public void Start(IServerSocket socket)
        {
            _socket = socket;
            var thread = new Thread(new ParameterizedThreadStart(ping));
            thread.Start(_socket);
        }

        private void ping(object serversocket)
        {
            
            while (true)
            {
                ((IServerSocket)serversocket).Send("Alive");
                Thread.Sleep(1000);
            }
        }


        public void Configure(XElement config)
        {
            
        }
    }
}
