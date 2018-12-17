namespace AutoServer.Interfaces
{
    public interface IStreamParser
    {
        void Add(byte[] data);

        bool HasNext();

        string GetNext();
    }
}
