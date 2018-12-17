using App_Data.Data.Context;
using System;
using System.Linq;
using WebApplication1.Services.Interfaces.Modules;

namespace WebApplication1.Services.Services.Modules
{
    public class PingModule : AbstractModule, IPingModule
    {
        public bool IsOnline()
        {
            if ((DateTime.Now - LastPing()) < new TimeSpan(0, 1, 0))
                return true;

            return false;
        }

        public DateTime LastPing()
        {
            _manager.BeginTransaction(System.Data.IsolationLevel.ReadUncommitted);

            var lastPing = (from p in _manager.modules_Ping
                           select p.LastPing).FirstOrDefault();

            _manager.CommitTransaction();

            return lastPing;
        }

        public override DTO.ModuleType Type
        {
            get { return DTO.ModuleType.Ping; }
        }


        public void Save()
        {
            ;
        }

        public PingModule(DataManager manager)
            : base(manager)
        {
        }

        public override void Initialize(int ClientId, string name)
        {
            _name = name;
        }
    }
}