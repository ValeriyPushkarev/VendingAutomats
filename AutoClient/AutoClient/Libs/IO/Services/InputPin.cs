using AutoClient.Libs.IO.DTO;
using AutoClient.Libs.IO.Interfaces;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Mono.Unix.Native;

namespace AutoClient.Libs.IO.Services
{
    class InputPin : IPin
    {
        private int _number;
        private string _directory;
        private PinParameters.Mode _mode;
        private PinParameters.Direction _direction;
        private PinParameters.Value _value;
        private CancellationTokenSource _tokenSource;
        private int _interruptFile;

        public PinParameters.Mode Mode
        {
            get
            {
                return _mode;
            }
        }

        public PinParameters.Direction Direction
        {
            get
            {
                return _direction;
            }
        }

        public PinParameters.Value Value
        {
            get
            {
                var val = File.ReadAllText(_directory + @"/value");
                return val=="1"?PinParameters.Value.high:PinParameters.Value.low;
            }
            set
            {
                ;
            }
        }

        public InputPin (int Number, PinParameters.EdgeEvent EdgeEvent = PinParameters.EdgeEvent.none)
        {
            if ((!PinUsage.InputPins.Contains(Number)) & (!PinUsage.OutputPins.Contains(Number)))
            {
                _mode = PinParameters.Mode.Discrete;
                _number = Number;
                _direction = PinParameters.Direction.In;

                PinUsage.InputPins.Add(Number);

                var num_str = Number.ToString();
                var exportPath = @"/sys/class/gpio/export"; 
                File.WriteAllText(exportPath, num_str);

                _directory = Directory.GetDirectories(@"/sys/class/gpio/", @"gpio" + Number + "*").FirstOrDefault<string>();

                File.WriteAllText(_directory + @"/direction", @"in");

                //инициализируем прерывание
                if (EdgeEvent != PinParameters.EdgeEvent.none)
                {
                    try
                    {
                        _tokenSource = new CancellationTokenSource();

                        File.WriteAllText(_directory + "/edge", EdgeEvent.ToString());

                        var interrupt = new ParameterizedThreadStart(InterruptTask);
                        interrupt.Invoke(new {token = _tokenSource.Token, directory = _directory, pinEvent = this.PinEvent});
                    }
                    catch
                    {
                        throw new Exception("Pin doesn't allow hardaware interrupts");
                    }
                }
            }
            else throw new Exception("Pin is used");
        }

        public void Close()
        {
            File.WriteAllText(@"/sys/class/gpio/unexport", _number.ToString());
            _tokenSource.Cancel();
            Syscall.close(_interruptFile);
        }

        private void InterruptTask(object parameters)
        {
            var token = (CancellationToken)parameters.GetType().GetField("token").GetValue(parameters);
            var directory = (string)parameters.GetType().GetField("directory").GetValue(parameters);
            var pinEvent = (EventHandler<string>)parameters.GetType().GetField("pinEvent").GetValue(parameters);

            var file = prepareInt(directory);

            try
            {
                while (token.IsCancellationRequested)
                {

                    waitInterrupt(file);
                    pinEvent.Invoke(this, directory);
                }
            }
            catch
            {

            }
        }

        private unsafe int prepareInt(string directory)
        {
            var buf = new byte[2];

            _interruptFile = Syscall.open(directory + @"/value", OpenFlags.O_RDWR);

            fixed (byte* pb = buf)
            {
                var res = (int)Syscall.pread(_interruptFile, pb, (ulong)1, 0);
            }

            return  _interruptFile;
        }

        private unsafe void waitInterrupt(int file)
        {
            var pfs = new Pollfd();
            pfs.fd = file;
            pfs.events = PollEvents.POLLPRI | PollEvents.POLLERR;
            pfs.revents = 0;

            var buf = new byte[2];

            fixed (byte* pb = buf)
            {
                var r = Syscall.poll(new[] { pfs }, -1);

                var res2 = (int)Syscall.pread(file, pb, (ulong)1, 0);
            }
        }

        public event EventHandler<string> PinEvent;
    }
}
