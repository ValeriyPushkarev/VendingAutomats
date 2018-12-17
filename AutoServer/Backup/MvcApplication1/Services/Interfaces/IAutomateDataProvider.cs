using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebApplication1.Services.Interfaces
{
    public interface IAutomateDataProvider
    {
        string[] GetAutomateNames();

        IAutomate GetAutomate(string automateName);

        IAutomate[] GetAutomates();
    }
}
