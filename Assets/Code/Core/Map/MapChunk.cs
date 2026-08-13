

using System.Collections.Generic;
using UnityEngine;

public class MapChunk : MonoBehaviour, IPoolable
{
    [SerializeField]
    private Transform decorationRoot;

    private readonly List<PooledDecoration> decorations = new();

    public Vector2Int Coordinate { get; private set; }

    public void Setup(
        Vector2Int coordinate,
        List<DecorationPool> pools,
        int decorationCount,
        float chunkSize)
    {
        Coordinate = coordinate;

        transform.position = new Vector3(
            coordinate.x * chunkSize,
            0f,
            coordinate.y * chunkSize
        );

        GenerateDecorations(
            pools,
            decorationCount,
            chunkSize
        );
    }

    private void GenerateDecorations(
        List<DecorationPool> pools,
        int count,
        float chunkSize)
    {
        for (int i = 0; i < count; i++)
        {
            ObjectPool pool = GetRandomPool(pools);

            if (pool == null)
                continue;

            GameObject obj = pool.Get();

            if (obj == null)
                continue;

            obj.transform.SetParent(
                decorationRoot,
                false
            );

            obj.transform.localPosition = new Vector3(
                Random.Range(
                    -chunkSize * 0.5f,
                    chunkSize * 0.5f
                ),
                0f,
                Random.Range(
                    -chunkSize * 0.5f,
                    chunkSize * 0.5f
                )
            );

            decorations.Add(
                new PooledDecoration(
                    pool,
                    obj
                )
            );
        }
    }

    private ObjectPool GetRandomPool(
        List<DecorationPool> pools)
    {
        float totalWeight = 0f;

        foreach (DecorationPool entry in pools)
            totalWeight += entry.Weight;

        if (totalWeight <= 0f)
            return null;

        float random = Random.Range(
            0f,
            totalWeight
        );

        foreach (DecorationPool entry in pools)
        {
            random -= entry.Weight;

            if (random <= 0f)
                return entry.Pool;
        }

        return pools[^1].Pool;
    }

    public void OnSpawn()
    {
    }

    public void OnDespawn()
    {
        foreach (PooledDecoration decoration in decorations)
        {
            if (decoration.obj != null)
                decoration.pool.Release(
                    decoration.obj
                );
        }

        decorations.Clear();
    }

    private class PooledDecoration
    {
        public readonly ObjectPool pool;
        public readonly GameObject obj;

        public PooledDecoration(
            ObjectPool pool,
            GameObject obj)
        {
            this.pool = pool;
            this.obj = obj;
        }
    }
}