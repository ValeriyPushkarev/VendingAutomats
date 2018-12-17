using App_Data.Data.Context;
using Microsoft.Practices.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApplication1.Services.Interfaces;
using WebApplication1.Services.Interfaces.Modules;

namespace WebApplication1.Services.Services
{
    public class ModuleDataProvider : IModuleDataProvider
    {
        private DataManager _manager;

        private IUnityContainer _container;

        private object _lock = new object();

        public ModuleDataProvider(DataManager manager, IUnityContainer container)
        {
            _manager = manager;
            _container = container;
        }
        public IModule[] GetModules(string automate)
        {
            var result = new List<IModule>();

            result.AddRange(LevelModules( automate));

            result.AddRange(PingModules(automate));

            return result.ToArray();
        }

        private IEnumerable<IModule> PingModules(string automate)
        {
            lock (_lock)
            {
                _manager.BeginTransaction(System.Data.IsolationLevel.ReadUncommitted);

                var tmp = (_manager.modules_Ping
                    .Select(t => new { t.Id, t.ClientId })).First();

                _manager.CommitTransaction();

                var module = _container.Resolve<IPingModule>();

                module.Initialize(tmp.ClientId, tmp.Id.ToString());

                return new List<IModule> { module };
            }
        }

        private IEnumerable<IModule> LevelModules(string automate)
        {
            lock (_lock)
            {

                var result = new List<IModule>();

                var clientIds = (from t in _manager.modules_Levels
                                 select new { t.ClientId, t.ModuleName }).Distinct().ToArray();
                var tmp = (from cm in clientIds
                           join lm in _manager.modules_LevelModules on new { cm.ClientId, cm.ModuleName } equals new { lm.ClientId, lm.ModuleName }
                           into tmpset
                           from subset in tmpset.DefaultIfEmpty()
                           select new
                           {
                               cm.ClientId,
                               cm.ModuleName,
                               MaxLevel = subset != null ? subset.MaxLevel : 100,
                               MinLevel = subset != null ? subset.MinLevel : 0,
                               SecondAlertLevel = subset != null ? subset.SecondAlertLevel : 0,
                               SecondAlertEnabled = subset != null ? subset.SecondAlertEnabled : false,
                               FirstAlertLevel = subset != null ? subset.FirstAlertLevel : 0,
                               FirstAlertEnabled = subset != null ? subset.FirstAlertEnabled : false
                           }).ToArray();

                foreach (var moduleConf in tmp)
                {
                    var mod = _container.Resolve<ILevelModule>();

                    mod.InitializeWithoutLoad(moduleConf.ClientId, moduleConf.ModuleName);

                    mod.MaxLevel = moduleConf.MaxLevel;
                    mod.MinLevel = moduleConf.MinLevel;

                    mod.AlertLevel1 = moduleConf.FirstAlertLevel;
                    mod.AlertLevel2 = moduleConf.SecondAlertLevel;

                    mod.AlertLevel1Enabled = moduleConf.FirstAlertEnabled;
                    mod.AlertLevel2Enabled = moduleConf.SecondAlertEnabled;

                    result.Add(mod);
                }

                return result;
            }
        }
    }
}