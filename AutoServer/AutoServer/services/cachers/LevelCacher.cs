using AutoServer.DTO;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AutoServer.services.cachers
{
    public class LevelCacher : BaseSqlCacher<LevelData>
    {
        private ServerParameters _parameters;

        public LevelCacher(ServerParameters parameters)
            : base(parameters, 100)
        {
        }

        protected override void Prepare(Queue<LevelData> items, SqlConnection connection)
        {
            var table = new DataTable();
            table.Columns.AddRange(new []
            {
                new DataColumn("ClientName"),
                new DataColumn("CreationDate"),
                new DataColumn("ModuleName"),
                new DataColumn("Level", typeof(double))
            });

            foreach (var item in items)
            {
                var row = table.NewRow();
                row["ClientName"] = item.Name;
                row["CreationDate"] = item.Date;
                row["ModuleName"] = item.ModuleName;
                row["Level"] = item.Level;

                table.Rows.Add(row);
            }

            SqlCommand command = new SqlCommand(
                        "modules.spLevelWrite", connection);
            command.CommandType = CommandType.StoredProcedure;
            SqlParameter tvpParam = command.Parameters.AddWithValue(
                "@items", table);
            tvpParam.SqlDbType = SqlDbType.Structured;

            command.ExecuteNonQuery();
        }
     
        
    }
}
