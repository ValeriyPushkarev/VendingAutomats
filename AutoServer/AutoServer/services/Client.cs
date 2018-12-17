using AutoServer.DTO;
using AutoServer.Interfaces;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Xml.Linq;

namespace AutoServer.services
{
    class Client : IClient
    {
        IClientManager _manager;
        IClientChecker _checker;
        IPacketParser _parser;
        NetworkStream _stream;
        IStreamParser _streamParser;

        TcpClient _client;
        string _login;

        public Client(IClientManager manager, IClientChecker checker,
            IPacketParser parser, IStreamParser streamParser)
        {
            _manager = manager;
            _checker = checker;
            _parser = parser;
            _streamParser = streamParser;
        }

        public async void Start(TcpClient tcpClient)
        {
            _client = tcpClient;
           _stream = tcpClient.GetStream();
           CheckLogin(_stream);
        }

        private async void CheckLogin(NetworkStream _stream)
        {
            var buf = new byte[1];
            await _stream.ReadAsync(buf,0,1);

            var available = _client.Available;
            var msg = new byte [available + 1];
            buf.CopyTo(msg,0);
            _stream.Read(msg,1,available);

            var msgStr = UTF8Encoding.UTF8.GetString(msg);

            var el = XElement.Parse(msgStr);
            var name = el.Attribute("name").Value;
            var pass = el.Attribute("pass").Value;

            _login = name;

            if (_checker.Check(name, pass))
            {

                Thread client = new Thread(new ParameterizedThreadStart(ClientWork));
                var parameters = new ClientConfiguration
                { 
                  tcpClient = _client, 
                  clientManager = _manager, 
                  packetParser = _parser,
                  streamParser = _streamParser
                };
                _stream.WriteByte(1);
                client.Start(parameters);
            }
            else
               _stream.WriteByte(0);
        }

        private void ClientWork(object parameters)
        {
            var param = (ClientConfiguration)parameters;
            var client = param.tcpClient;
            var manager = param.clientManager;
            var parser = param.packetParser;
            var streamParser = param.streamParser;

            var _stream = _client.GetStream();
            while (true)
            {
                var first = new byte[1];
                while (_stream.Read(first, 0, 1) == 0)
                {
                    Thread.Sleep(100);
                }

                streamParser.Add(first);

                var available = _client.Available;
                var msg = new byte[available];
             
                if (available > 0)
                {
                    _stream.Read(msg, 0, available);

                    streamParser.Add(msg);
                }
                while (streamParser.HasNext())
                {
                    var elements = @"<root>" + streamParser.GetNext() + @"</root>";

                    var el = XElement.Parse(elements);

                    var elementsTmp = el.Elements();

                    foreach (var element in el.Elements())
                        parser.Parse(element, _login);
                }
            }
        }
    }
}
