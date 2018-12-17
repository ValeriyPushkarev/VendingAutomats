using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebApplication1.Services.Interfaces
{
    public interface IAutomate : ISaveable
    {
        void Initialize(string Name);

        string Name { get; }

        string Address { get; set; }

        string Position { get; set; }

        string Desc { get; set; }

        IModule[] Modules { get; }
    }
}
