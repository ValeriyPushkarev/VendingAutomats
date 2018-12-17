using AutoServer.Interfaces;
using System.Data.SqlClient;

namespace AutoServer.services
{
    class ClientChecker : IClientChecker
    {
        private SqlConnection _connection;
        private string sqlCommandText = 
        @"SELECT COUNT(*)
          FROM main.Clients cl
          WHERE cl.Name = @Name AND cl.Password = @Password";
            
        public ClientChecker(SqlConnection connection)
        {
            _connection = connection;
        }

        public bool Check(string name, string pass)
        {
            var command = new SqlCommand();
            command.CommandText = sqlCommandText;
            command.Parameters.AddWithValue("@Name", name);
            command.Parameters.AddWithValue("@Password", pass);

            command.Connection = _connection;

            var result = (int)command.ExecuteScalar();

            if (result > 0) return true;

            return false;
        }
    }
}
