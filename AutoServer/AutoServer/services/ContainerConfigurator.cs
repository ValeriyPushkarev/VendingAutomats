using AutoServer.DTO;
using AutoServer.Interfaces;
using AutoServer.services.cachers;
using AutoServer.services.parsers;
using Microsoft.Practices.Unity;
using System.Data.SqlClient;

namespace AutoServer.services
{
    public class ContainerConfigurator
    {
        public static void Configure(IUnityContainer container, string connectionString)
        {
            var sqlConnection = new SqlConnection(connectionString);
            sqlConnection.Open();

            var parameters = new ServerParameters
            {
                SqlConnection = connectionString
            };

            container.RegisterInstance<ServerParameters>(parameters);
            container.RegisterInstance<IClientManager>(new ClientManager());
            container.RegisterInstance<IClientChecker>(new ClientChecker(sqlConnection));

            container.RegisterType<IClient, Client>();

            container.RegisterType<IPacketParser, PacketParser>();
            container.RegisterType<IStreamParser, StreamParser>();

            container.RegisterInstance<ICacher<LevelData>>(new LevelCacher(parameters));
            container.RegisterInstance<ICacher<PingData>>(new PingCacher(parameters));

            container.RegisterType<ILocalParser, PingParser>("ping", new HierarchicalLifetimeManager());
            container.RegisterType<ILocalParser, LevelParser>("level", new HierarchicalLifetimeManager());

            
           
            
        }
    }
}
