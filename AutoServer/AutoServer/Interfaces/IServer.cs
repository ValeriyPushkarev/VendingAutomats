namespace AutoServer.Interfaces
{
    public interface IServer
    {
        void Start(int port);

        void Stop();
    }
}
