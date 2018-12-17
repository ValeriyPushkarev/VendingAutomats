using AutoClient.Interfaces;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace AutoClient.Services
{
    class Logger : ILogger
    {
        private object _lock = new object();
        private object _lock2 = new object();
        private Stream _fileStream;
        private long _maxLength = 2000000;

        public Logger(string filename)
        {
            _fileStream = File.Open(filename, FileMode.Append);
        }

        public void LogSocket(IServerSocket socket, string message)
        {
            lock (_lock)
            {
                var data = new XElement(socket.Type,
                       new object[] {
                                    new XAttribute("Time",DateTime.Now.ToString())
                                   ,new XElement(socket.Name, new [] {new XElement("Message",message)})
                                 });

                WriteLog(data);
            }
        }

        public void Log(string name, string shortDesc, string message)
        {
            lock (_lock)
            {
                var data = new XElement(name,
                    new[] { 
                            new XElement("Desc", shortDesc)
                           ,new XElement("Message", message) 
                          });

                WriteLog(data);
            }
        }

        private void WriteLog(XElement item)
        {
            lock (_lock2)
            {
                byte[] buffer = UTF8Encoding.UTF8.GetBytes(item.ToString()); 

                if (_fileStream.Position > _maxLength)
                    _fileStream.Position = 0;

                _fileStream.Write(buffer, 0, buffer.Length);
                _fileStream.Flush();
            }
        }

        ~Logger()
        {
            _fileStream.Close();
        }
    }
}
