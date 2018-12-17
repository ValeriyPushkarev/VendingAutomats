using AutoServer.DTO;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AutoServer.services.cachers
{
    public class PingCacher : BaseSqlCacher<PingData>
    {
        private ServerParameters _parameters;

        public PingCacher(ServerParameters parameters)
            : base(parameters, 10)
        {
        }

        protected override void Prepare(Queue<PingData> items, SqlConnection connection)
        {
            var table = new DataTable();
            table.Columns.AddRange(new[]
            {
                new DataColumn("ClientName"),
                new DataColumn("ChangeDate")
            });

            foreach (var item in items)
            {
                var row = table.NewRow();
                row["ClientName"] = item.Name;
                row["ChangeDate"] = item.Date;

                table.Rows.Add(row);
            }

            SqlCommand command = new SqlCommand(
                        "modules.spPingWrite", connection);
            command.CommandType = CommandType.StoredProcedure;
            SqlParameter tvpParam = command.Parameters.AddWithValue(
                "@items", table);
            tvpParam.SqlDbType = SqlDbType.Structured;

            command.ExecuteNonQuery();
        }
     
        
    }
}
