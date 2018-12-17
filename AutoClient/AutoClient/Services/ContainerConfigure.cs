using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Practices.Unity;
using AutoClient.Interfaces;
using AutoClient.Services.Modules;
using System.Collections.Concurrent;

namespace AutoClient.Services
{
    static class ContainerConfigurator
    {
        public static void Configure(IUnityContainer container,string name)
        {
            ConcurrentQueue<string> messagesToSend = new ConcurrentQueue<string>();
            Queue<IServerSocket> sockets = new Queue<IServerSocket>();

            container.RegisterInstance<ILogger>(new Logger("log.txt"));
            
            container.RegisterType<IRouter, Router>(new InjectionProperty("sockets", sockets));
            container.RegisterType<IClient, Client>(new InjectionProperty("messages", messagesToSend));
            
            container.RegisterType<IModule, PingModule>("ping");
            container.RegisterType<IModule, ConfigurationInfo>("configurationInfo");

            var mConf = new ModulesConfigurator(container);
            mConf.Configure(name, sockets, messagesToSend);
                
        }
    }
}
