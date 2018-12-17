using AutoServer.DTO;
using AutoServer.Interfaces;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace AutoServer.services.cachers
{
    public abstract class BaseSqlCacher <TItem> : ICacher<TItem>
    {
        private Queue<TItem> _items;

        private int _length;

        private ServerParameters _parameters;

        private object _lock;

        public BaseSqlCacher(ServerParameters parameters, int length)
        {
            _lock = new object();
            _items = new Queue<TItem>();
            _parameters = parameters;
            _length = length;
        }


        private void CheckLength()
        {
            if (_items.Count() > _length)
            {
                Process(_items);
                _items.Clear();
            }
        }

        private void Process(Queue<TItem> items)
        {
            using (var connection = new SqlConnection(_parameters.SqlConnection))
            {
                connection.Open();
                Prepare(items, connection);
            }
        }

        protected abstract void Prepare(Queue<TItem> items, SqlConnection connection);
        
        public void Add(TItem item)
        {
            lock (_lock)
            {
                _items.Enqueue(item);
                CheckLength();
            }
        }
    }
}
