using AutoClient.Interfaces;
using Microsoft.Practices.Unity;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;


namespace AutoClient.Services
{
    class ModulesConfigurator : IModulesConfigurator
    {
        private IUnityContainer _container;
        public ModulesConfigurator(IUnityContainer container)
        {
            _container = container;
        }
        public void Configure(string clientName, Queue<IServerSocket> sockets, ConcurrentQueue<string> messages)
        {
            var file = File.Open("modules.conf", FileMode.Open, FileAccess.Read);
            var modulesConfig = XDocument.Load(file);
            file.Close();

            foreach (var moduleType in modulesConfig.Element("Configuration").Elements("Type"))
            {
                var typeName = moduleType.Attribute("typeName").Value;
                foreach (var module in moduleType.Elements("Element"))
                {
                    var name = module.Attribute("name").Value;
                    
                    var socket = new ServerSocket(clientName,typeName,name,messages);
                    sockets.Enqueue(socket);

                    var client = _container.Resolve<IModule>(typeName);

                    client.Configure(module);
                    client.Start(socket);
                }
            }
            
            
        }
    }
}
