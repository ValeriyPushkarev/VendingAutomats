namespace WebApplication1.Services.Interfaces
{
    public interface IAutomateDataProvider
    {
        string[] GetAutomateNames();

        IAutomate GetAutomate(string automateName);

        IAutomate[] GetAutomates();
    }
}
