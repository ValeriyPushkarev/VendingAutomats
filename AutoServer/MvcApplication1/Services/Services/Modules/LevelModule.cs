using App_Data.Data.Context;
using System;
using System.Collections.Generic;
using System.Linq;
using BLToolkit.Data.Linq;
using WebApplication1.Services.Interfaces;
using WebApplication1.Services.Interfaces.Modules;
using App_Data.Data.Context.modules;

namespace WebApplication1.Services.Services.Modules
{
    public class LevelModule : AbstractModule, ILevelModule
    {
        private double _maxLevel;
        private double _minLevel;
        private double _alertLevel1;
        private double _alertLevel2;
        private bool _alertLevel1Enabled;
        private bool _alertLevel2Enabled;

        double ILevelModule.MaxLevel
        {
            get
            {
                return _maxLevel;
            }
            set
            {
                _maxLevel = value;
            }
        }

        double ILevelModule.MinLevel
        {
            get
            {
                return _minLevel;
            }
            set
            {
                _minLevel = value;
            }
        }

        double ILevelModule.AlertLevel1
        {
            get
            {
                return _alertLevel1;
            }
            set
            {
                _alertLevel1 = value;
            }
        }

        bool ILevelModule.AlertLevel1Enabled
        {
            get
            {
                return _alertLevel1Enabled;
            }
            set
            {
                _alertLevel1Enabled = value;
            }
        }

        double ILevelModule.AlertLevel2
        {
            get
            {
                return _alertLevel2;
            }
            set
            {
                _alertLevel2 = value;
            }
        }

        bool ILevelModule.AlertLevel2Enabled
        {
            get
            {
                return _alertLevel2Enabled;
            }
            set
            {
                _alertLevel2Enabled = value;
            }
        }

        public override DTO.ModuleType Type
        {
            get { return DTO.ModuleType.Level; }
        }

        Dictionary<DateTime, double> ILevelModule.GetLevelsFromInterval(DateTime datefrom, DateTime to, int Resolution = 100)
        {
            _manager.BeginTransaction(System.Data.IsolationLevel.ReadUncommitted);

            var result = new Dictionary<DateTime, double>();

            using (var reader = _manager.SetSpCommand("modules.spGetLevels",
                _manager.Parameter("@DateFrom", datefrom),
                _manager.Parameter("@DateTo", to),
                _manager.Parameter("@Resolution", Resolution),
                _manager.Parameter("@ModuleName", _name),
                _manager.Parameter("@ClientId", _clientId)
                ).ExecuteReader())
            {
                while (reader.Read())
                {
                    result.Add(reader.GetDateTime(0), reader.GetDouble(1));
                }
            }

            _manager.CommitTransaction();

            return result;
        }

        string IModule.Name
        {
            get { return _name; }
        }

        DTO.ModuleType IModule.Type
        {
            get { return DTO.ModuleType.Level; }
        }

        void ISaveable.Save()
        {
            if ((from cl in _manager.main_Clients
                 join lm in _manager.modules_LevelModules on cl.Id equals lm.ClientId
                 select new { lm.ModuleName }
                ).Any())
            {
                _manager.GetTable<LevelModules>()
                    .Update(
                    t => (t.ClientId == _clientId) & (t.ModuleName == _name),
                    t => new LevelModules
                    {
                        FirstAlertEnabled = _alertLevel1Enabled,
                        FirstAlertLevel = _alertLevel1,
                        SecondAlertEnabled = _alertLevel2Enabled,
                        SecondAlertLevel = _alertLevel2,
                        MaxLevel = _maxLevel,
                        MinLevel = _minLevel,
                    }
                    );
            }
            else
            {
                _manager.GetTable<LevelModules>()
                    .Insert( () =>
                    new LevelModules
                    {
                        ClientId = _clientId,
                        ModuleName = _name,
                        FirstAlertEnabled = _alertLevel1Enabled,
                        FirstAlertLevel = _alertLevel1,
                        SecondAlertEnabled = _alertLevel2Enabled,
                        SecondAlertLevel = _alertLevel2,
                        MaxLevel = _maxLevel,
                        MinLevel = _minLevel,
                    }
                    );
            }
        }

        public LevelModule(DataManager manager)
            : base(manager)
        {
        }

        public int ClientId
        {
            get { return _clientId; }
        }

        public override void Initialize(int ClientId, string name)
        {
            _clientId = ClientId;
            _name = name;
            var clientIds = (from t in _manager.modules_Levels
                             where t.ClientId == _clientId
                             select new { t.ClientId, t.ModuleName }).Distinct();

            var result = (from cm in clientIds
                      join lm in _manager.modules_LevelModules on new { cm.ClientId, cm.ModuleName } equals new { lm.ClientId, lm.ModuleName }
                      into tmpset
                      from subset in tmpset.DefaultIfEmpty()
                      select new
                      {
                          cm.ClientId,
                          cm.ModuleName,
                          subset.MaxLevel,
                          subset.MinLevel,
                          subset.SecondAlertLevel,
                          subset.SecondAlertEnabled,
                          subset.FirstAlertLevel,
                          subset.FirstAlertEnabled
                      }).FirstOrDefault();

            _alertLevel1Enabled = result.FirstAlertEnabled;
            _alertLevel1 = result.FirstAlertLevel;

            _alertLevel2Enabled = result.SecondAlertEnabled;
            _alertLevel2 = result.SecondAlertLevel;

            _minLevel = result.MinLevel;
            _maxLevel = result.MaxLevel;
        }

        public KeyValuePair<DateTime, double> GetLatestLevel()
        {
            _manager.BeginTransaction(System.Data.IsolationLevel.ReadUncommitted);

            var result = (from l in _manager.modules_Levels
                          where (l.ClientId == _clientId && l.ModuleName == _name)
                          orderby l.CreationDate descending
                          select new { l.CreationDate, l.Level }).FirstOrDefault();

            _manager.CommitTransaction();

            return new KeyValuePair<DateTime, double>(result.CreationDate, result.Level);
        }

        public KeyValuePair<DateTime, double> GetLatestLevelPercents()
        {
            var l = GetLatestLevel();
            return new KeyValuePair<DateTime, double>(
                l.Key, (l.Value - _minLevel) / (_maxLevel - _minLevel));
        }
    }
}