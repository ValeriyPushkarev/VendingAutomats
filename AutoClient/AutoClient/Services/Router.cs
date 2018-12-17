using AutoClient.Interfaces;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace AutoClient.Services
{
    class Router : IRouter
    {
        private ILogger _logger;

        private Queue<IServerSocket> _sockets;
        public Queue<IServerSocket> sockets
        {
            get
            {
                return _sockets;
            }
            set
            {
                _sockets = value;
            }
        }

        public Router(ILogger logger)
        {
            _logger = logger;
        }

        public void Route(XElement packet)
        {
            var moduleType = packet.Element("packet").Attribute("moduleType").Value;
            var moduleName = packet.Element("packet").Attribute("moduleName").Value ?? null;

            foreach (var socket in _sockets)
            {
                if (socket.Type == moduleType)
                {
                    if ((moduleName == null)|| (moduleName == socket.Name))
                        socket.Send(packet.Element("packet").Value);
                }
            }
        }
    }
}
