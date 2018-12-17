using AutoClient.Interfaces;
using AutoClient.Services;
using AutoClient.Services.Modules;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Practices.Unity;
using AutoClient.Libs.IO.Services;

namespace AutoClient
{
    class Program
    {
        static void Main(string[] args)
        {
            var Pin = new InputPin(62, AutoClient.Libs.IO.DTO.PinParameters.EdgeEvent.both);

            Pin.PinEvent += Pin_PinEvent;
            //var name = "Name1";
            //var login = "login";
            //var pass = "pass";
            //var host = "192.168.0.102";
            //var port = 12321;

            //UnityContainer container = new UnityContainer();
            //ContainerConfigurator.Configure(container, name);
            
            //var Client = container.Resolve<IClient>();

            //Client.Configure(host, port, login, pass);
            //Client.Start();
        }

        static void Pin_PinEvent(object sender, string e)
        {
            Console.WriteLine("Something happens on" + e);
        }
    }
}
