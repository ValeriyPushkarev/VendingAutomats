using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApplication1.Services.Interfaces;
using WebApplication1.Services.Interfaces.Modules;
using WebApplication1.Services.Services.Modules;

namespace WebApplication1.Services.Services
{
    public static class ContainerConfiguration
    {
        public static void Configure(IUnityContainer container)
        {
            container.RegisterType<IAutomateDataProvider, AutomateDataProvider>(new HierarchicalLifetimeManager());

            container.RegisterType<IModuleDataProvider, ModuleDataProvider>(new HierarchicalLifetimeManager());

            container.RegisterType<IAutomate, Automate>(new PerResolveLifetimeManager());

            container.RegisterType<IModule, PingModule>("Ping" ,new PerResolveLifetimeManager());

            container.RegisterType<IPingModule, PingModule>(new PerResolveLifetimeManager());

            container.RegisterType<IModule, LevelModule>("Level", new PerResolveLifetimeManager());

            container.RegisterType<ILevelModule, LevelModule>(new PerResolveLifetimeManager());
        }
    }
}