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

        public AutomateDataProvider(IUnityContainer container, DataManager manager)
        {
            _container = container;
            _manager = manager;
        }

        public string[] GetAutomateNames()
        {
            var result = from t in _manager.main_Clients
                         select (t.Name);

            return result.ToArray();
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

            foreach (var autoName in GetAutomateNames())
            {
                result.Add(GetAutomate(autoName));
            }

            return result.ToArray();
        }
    }
}