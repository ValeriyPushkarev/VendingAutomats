using App_Data.Data.Context;
using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebApplication1.Services.Interfaces;

namespace WebApplication1.Services.Services
{
    public class AutomateDataProvider : IAutomateDataProvider
    {
        private IUnityContainer _container;

        private DataManager _manager;

        private object _lock = new object();
        public AutomateDataProvider(IUnityContainer container, DataManager manager)
        {
            _container = container;
            _manager = manager;
        }

        public string[] GetAutomateNames()
        {
            lock (_lock)
            {
                var result = (from t in _manager.main_Clients
                              select (t.Name)).ToArray();
                return result;
            }
        }

        public IAutomate GetAutomate(string automateName)
        {
            var automate = _container.Resolve<IAutomate>();

            automate.Initialize(automateName);

            return automate;
        }

        public IAutomate[] GetAutomates()
        {
            var result = new List<IAutomate>();

            var names = GetAutomateNames();

            foreach (var autoName in names)
            {
                result.Add(GetAutomate(autoName));
            }

            return result.ToArray();
        }
    }
}