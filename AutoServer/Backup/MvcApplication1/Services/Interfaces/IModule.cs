using System;
using System.Collections.Generic;
using System.Linq;
using System.Drawing;
using System.Web;
using WebApplication1.Services.DTO;

namespace WebApplication1.Services.Interfaces
{
    public interface IModule : ISaveable
    {
        string Name { get; }

        int ClientId { get; }

        ModuleType Type { get; }

        void Initialize(string automateName, string name);

        void Initialize(int ClientId, string name);

        void InitializeWithoutLoad(int ClientId, string name);
    }
}