using AutoClient.Interfaces;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace AutoClient.Services
{
    class Client : IClient
    {
        string _name;
        string _pass;

        string _host;
        int _port;
        TcpClient _client;

        ILogger _logger;
        IRouter _router;

        public ConcurrentQueue<string> messages { get; set; }

        public Client(ILogger logger, IRouter router)
        {
            _logger = logger;
            _router = router;
        }

        public void Configure(string host, int port, string login, string pass)
        {
            _name = login;
            _pass = pass;
            _host = host;
            _port = port;
            _client = new TcpClient();
        }

        public void Start()
        {
            _client.Connect(_host, _port);
            using(var stream = _client.GetStream())
            {
                //отсылаем логин\пасс
                XElement el = new XElement("Login", new[] 
                {new XAttribute("name",_name)
                ,new XAttribute("pass",_pass)
                });

                var loginStr = el.ToString();
                var loginBytes = UTF8Encoding.UTF8.GetBytes(loginStr);
                stream.Write(loginBytes,0,loginBytes.Length);

                var receive = new Thread(new ParameterizedThreadStart(Receive));
                receive.Start(new object[] { stream, _router });

                while (true)
                {
                    //Отсылаем все из очереди
                    while (messages.Count() > 0)
                    {
                        var message ="";
                        messages.TryDequeue(out message);

                        var bytes = UTF8Encoding.UTF8.GetBytes(message);
                        stream.Write(bytes, 0, bytes.Length);
                    }

                    Thread.Sleep(1000);
                }
            }
        }

        private void Receive(object array)
        {
            NetworkStream stream = (NetworkStream)((object[])array)[0];
            IRouter router = (IRouter)((object[])array)[1];

            var firstByte = new byte[1];
            while (true)
            {
                //получаем и роутим если есть чо
                var recTask = stream.ReadAsync(firstByte, 0, 1);
                recTask.Wait();
                
                var buf = new byte[_client.Available + 1];
                stream.Read(buf, 1, _client.Available);

                firstByte.CopyTo(buf, 0);

                try
                {
                    var xel = XElement.Parse(UTF8Encoding.UTF8.GetString(buf));
                    router.Route(xel);
                }
                catch
                {
                    _logger.Log("Client", "Пришел некорректный пакет", UTF8Encoding.UTF8.GetString(buf).ToString());
                }
            }
        }
    }
}
