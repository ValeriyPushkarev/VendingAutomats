using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoClient.Libs.IO.DTO
{
    public static class PinParameters
    {
        public enum Mode { Discrete, PWM };

        public enum Direction { In, Out };

        public enum Value { high, low };

        public enum EdgeEvent { none, rise, fall, both };
    }
}
