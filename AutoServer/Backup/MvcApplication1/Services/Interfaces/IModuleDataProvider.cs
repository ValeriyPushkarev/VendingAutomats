using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebApplication1.Services.Interfaces
{
    public interface IModuleDataProvider
    {
        IModule[] GetModules(string automate);
    }
}
