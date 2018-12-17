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
