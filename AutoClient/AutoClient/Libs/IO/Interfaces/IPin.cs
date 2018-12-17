using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoClient.Libs.IO.DTO;

namespace AutoClient.Libs.IO.Interfaces
{
    interface IPin
    {
        PinParameters.Mode Mode { get; }

        PinParameters.Direction Direction { get; }

        PinParameters.Value Value { get; set; }

        event EventHandler<string> PinEvent;

        void Close();
    }
}
