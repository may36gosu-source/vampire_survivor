public class DecorationPool
{
    public ObjectPool Pool { get; }
    public float Weight { get; }

    public DecorationPool(ObjectPool pool, float weight)
    {
        Pool = pool;
        Weight = weight;
    }
}