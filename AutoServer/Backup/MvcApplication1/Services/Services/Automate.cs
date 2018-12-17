using App_Data.Data.Context;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using WebApplication1.Services.Interfaces;

namespace WebApplication1.Services.Services
{
    public class Automate : IAutomate
    {
        private string _name;
        private string _address;
        private string _desc;
        private string _position;
        private string _connectionString;
        private DataManager _manager;

        private IModule[] _modules;

        private IModuleDataProvider _moduleProvider;

        public string Name
        {
            get { return _name; }
        }

        public string Address
        {
            get { return _address; }
            set { _address = value; }
        }

        public string Desc
        {
            get { return _desc; }
            set { _desc = value; }
        }

        public IModule[] Modules
        {
            get { return _modules; }
        }

        public string Position
        {
            get
            {
                return _position;
            }
            set
            {
                _position = value;
            }
        }

        public Automate(IModuleDataProvider moduleProvider, DataManager manager)
        {
            _moduleProvider = moduleProvider;
            _manager = manager;
            _connectionString = ConfigurationManager.ConnectionStrings["DataServer"].ConnectionString;
        }

        private void LoadValues()
        {
            var result =( from cl in _manager.main_Clients
                     join clprop in _manager.main_ClientProperties on cl.Id equals clprop.ClientId into vals
                     from val in vals.DefaultIfEmpty()
                     where cl.Name == _name
                     select new { val.Address, val.Desc, val.Position }).FirstOrDefault();

            _address = result.Address;
            _position = result.Position;
            _desc = result.Desc;
        }

        private void SaveValues()
        {
            var connection = new SqlConnection(_connectionString);
            var command = connection.CreateCommand();

            connection.Open();

            command.CommandText = "Main.[UpdateClientProperties]";

            command.CommandType = System.Data.CommandType.StoredProcedure;

            command.Parameters.AddWithValue("@Name", _name);
            command.Parameters.AddWithValue("@Desc", _desc);
            command.Parameters.AddWithValue("@Address", _address);
            command.Parameters.AddWithValue("@Position", _position);

            command.ExecuteNonQuery();

            connection.Close();
        }

        public void Save()
        {
            SaveValues();

            foreach (ISaveable module in _modules)
            {
                module.Save();
            }
        }

        public void Initialize(string Name)
        {
            _name = Name;
            LoadValues();
            _modules = _moduleProvider.GetModules(_name);
        }
    }
}