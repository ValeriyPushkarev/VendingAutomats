using System;

namespace WebApplication1.Services.Interfaces.Modules
{
    public interface IPingModule : IModule
    {
        bool IsOnline();

        DateTime LastPing();
    }
}
