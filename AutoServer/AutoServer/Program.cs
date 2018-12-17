using Microsoft.Practices.Unity;
using AutoServer.services;

namespace AutoServer
{
    class Program
    {
        static void Main(string[] args)
        {
            var container = new UnityContainer();
            ContainerConfigurator.Configure(container, System.Configuration.ConfigurationManager.ConnectionStrings["Default"].ConnectionString);

            var server = new Server(container);
            server.Start(12321);
        }
    }
}
