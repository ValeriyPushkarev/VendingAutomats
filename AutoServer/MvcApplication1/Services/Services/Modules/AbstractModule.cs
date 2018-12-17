using App_Data.Data.Context;
using System;
using System.Linq;
using WebApplication1.Services.DTO;
using WebApplication1.Services.Interfaces;

namespace WebApplication1.Services.Services.Modules
{
    public abstract class AbstractModule : IModule
    {
        protected string _name;
        protected int _clientId;
        protected DataManager _manager;

        public AbstractModule(DataManager manager)
        {
            _manager = manager;
        }

        public void InitializeWithoutLoad(int ClientId, string name)
        {
            _clientId = ClientId;
            _name = name;
        }

        public void Initialize(string automateName, string name)
        {
            var clientId = (from val in _manager.main_Clients
                            where val.Name == automateName
                            select val.Id).FirstOrDefault();

            Initialize(clientId, name);
        }

        public abstract void Initialize(int ClientId, string name);

        public string Name
        {
            get { return _name; }
        }

        public int ClientId
        {
            get { return _clientId; }
        }

        public virtual DTO.ModuleType Type
        {
            get { return (ModuleType)0; }
        }

        public void Save()
        {
            throw new NotImplementedException();
        }
    }
}