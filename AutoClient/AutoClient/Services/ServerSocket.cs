using AutoClient.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Collections.Concurrent;
using System.Xml.Linq;
namespace AutoClient.Services
{
    class ServerSocket : IServerSocket
    {
        private string _name;
        private string _moduleName;
        private string _moduleType;

        public string Name { get { return _moduleName; } }
        public string Type { get { return _moduleType; } }

        private ConcurrentQueue<string> _messages;

        public ServerSocket(string name, string moduleType, string moduleName, ConcurrentQueue<string> messages)
        {
            _name = name;
            _moduleType = moduleType;
            _moduleName = moduleName;
            _messages = messages;

        }
        public void Send(object data)
        {
            var doc = new XDocument();
            doc.Add(
                new XElement("packet", new object[] 
                {
                    new XAttribute("name",_name)
                   ,new XAttribute("moduleType",_moduleType)
                   ,new XAttribute("moduleName",_moduleName)
                   ,new XElement("data",data)
                }
                ));
            _messages.Enqueue(doc.ToString());
        }

        public event ServerSend Receive;

    }
}
