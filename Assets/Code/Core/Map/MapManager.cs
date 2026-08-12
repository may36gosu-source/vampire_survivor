using System.Collections.Generic;
using UnityEngine;

public class MapManager : MonoBehaviour
{
    [Header("Player")]
    [SerializeField] private Transform player;

    [Header("Map")]
    [SerializeField] private Transform chunkRoot;
    [SerializeField] private Transform poolRoot;
    [SerializeField] private GameObject chunkPrefab;
    [SerializeField] private float chunkSize = 20f;

    [Header("Decoration")]
    [SerializeField] private GameObject grassPrefab;
    [SerializeField] private GameObject flowerPrefab;
    [SerializeField] private GameObject flower02Prefab;
    [SerializeField] private GameObject flower03Prefab;
    [SerializeField] private GameObject flower04Prefab;

    [SerializeField] private int decorationCount = 25;

    private ObjectPool chunkPool;
    private readonly List<ObjectPool> decorationPools = new();

    private readonly Dictionary<Vector2Int, MapChunk> activeChunks = new();

    private void Awake()
    {
        chunkPool = new ObjectPool(chunkPrefab, 9, chunkRoot);

        decorationPools.Add(new ObjectPool(grassPrefab, 30, poolRoot));
        decorationPools.Add(new ObjectPool(flowerPrefab, 10, poolRoot));
        decorationPools.Add(new ObjectPool(flower02Prefab, 10, poolRoot));
        decorationPools.Add(new ObjectPool(flower03Prefab, 10, poolRoot));
        decorationPools.Add(new ObjectPool(flower04Prefab, 10, poolRoot));
    }

    private void Start()
    {
        // SpawnTestChunk();

        LoadInitialChunks();
    }

    private void LoadInitialChunks()
    {
        for (int x = -1; x <= 1; x++)
        {
            for (int z = -1; z <= 1; z++)
            {
                SpawnChunk(new Vector2Int(x, z));
            }
        }
    }

    private void SpawnChunk(Vector2Int coordinate)
    {
        GameObject obj = chunkPool.Get();

        if (obj == null)
            return;

        MapChunk chunk = obj.GetComponent<MapChunk>();

        if (chunk == null)
        {
            chunkPool.Release(obj);
            return;
        }

        chunk.Setup(
            coordinate,
            decorationPools,
            decorationCount,
            chunkSize
        );

        activeChunks.Add(coordinate, chunk);
    }

    private void SpawnTestChunk()
    {
        GameObject obj = chunkPool.Get();

        if (obj == null)
            return;

        MapChunk chunk = obj.GetComponent<MapChunk>();

        if (chunk == null)
        {
            chunkPool.Release(obj);
            return;
        }

        chunk.Setup(
            Vector2Int.zero,
            decorationPools,
            decorationCount,
            chunkSize
        );
    }
}