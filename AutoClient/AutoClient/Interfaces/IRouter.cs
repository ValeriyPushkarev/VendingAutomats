using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace AutoClient.Interfaces
{
    public interface IRouter
    {
        void Route(XElement packet);

    }
}
