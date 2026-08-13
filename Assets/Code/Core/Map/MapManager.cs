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
    [SerializeField] private List<DecorationConfig> decorations = new();
    [SerializeField, Min(0)] private int decorationCount = 25;

    private ObjectPool chunkPool;
    private readonly List<DecorationPool> decorationPools = new();
    private readonly Dictionary<Vector2Int, MapChunk> activeChunks = new();

    private Vector2Int currentPlayerChunk; // 
    private const int ChunkDistance = 2; // 1 chunk mỗi hướng 3 × 3

    private void Awake()
    {
        chunkPool = new ObjectPool(chunkPrefab, 27, chunkRoot);

        foreach (DecorationConfig config in decorations)
        {
            if (config.Prefab == null)
                continue;

            ObjectPool pool = new ObjectPool(
                config.Prefab, config.PreloadCount, poolRoot
            );

            decorationPools.Add(
                new DecorationPool(pool, config.Weight)
            );
        }
    }

    private void Start()
    {
        LoadInitialChunks();

        currentPlayerChunk = GetPlayerChunk();

        // DebugRequiredChunks();
    }

    private void LoadInitialChunks()
    {
        // for (int x = -1; x <= 1; x++)
        // {
        //     for (int z = -1; z <= 1; z++)
        //     {
        //         SpawnChunk(new Vector2Int(x, z));
        //     }
        // }
        currentPlayerChunk = GetPlayerChunk();

        HashSet<Vector2Int> requiredChunks = GetRequiredChunks(currentPlayerChunk);

        SpawnMissingChunks(requiredChunks);
    }

    private void Update()
    {
        UpdateChunks();
    }

    // 9 chunk
    private HashSet<Vector2Int> GetRequiredChunks(Vector2Int playerChunk)
    {
        HashSet<Vector2Int> requiredChunks  = new();

        for (int x = -ChunkDistance; x <= ChunkDistance; x++)
        {
            for (int z = -ChunkDistance; z <= ChunkDistance; z++)
            {
                requiredChunks .Add(
                    new Vector2Int(playerChunk.x + x,playerChunk.y + z)
                );
            }
        }

        return requiredChunks;
    }

    private void UpdateChunks()
    {
        Vector2Int playerChunk = GetPlayerChunk();

        if (playerChunk == currentPlayerChunk)
            return;

        currentPlayerChunk = playerChunk;

        HashSet<Vector2Int> requiredChunks = GetRequiredChunks(playerChunk);

        SpawnMissingChunks(requiredChunks);

        ReleaseUnusedChunks(requiredChunks);
    }


    private void SpawnMissingChunks(HashSet<Vector2Int> requiredChunks)
    {
        foreach (Vector2Int coordinate in requiredChunks)
        {
            if (activeChunks.ContainsKey(coordinate))
                continue;

            SpawnChunk(coordinate);
        }
    }

    private void ReleaseUnusedChunks(HashSet<Vector2Int> requiredChunks)
    {
        List<Vector2Int> unused = new();

        foreach (Vector2Int coordinate in activeChunks.Keys)
        {
            if (!requiredChunks.Contains(coordinate))
                unused.Add(coordinate);
        }

        foreach (Vector2Int coordinate in unused)
        {
            MapChunk chunk = activeChunks[coordinate];

            activeChunks.Remove(coordinate);

            chunkPool.Release(chunk.gameObject);
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

        chunk.Setup(coordinate, decorationPools, decorationCount, chunkSize);

        activeChunks.Add(coordinate, chunk);
    }


    private void DebugRequiredChunks()
    {
        HashSet<Vector2Int> requiredChunks  =
            GetRequiredChunks(currentPlayerChunk);

        Debug.Log(
            $"Player Chunk: {currentPlayerChunk}"
        );

        foreach (Vector2Int coordinate in requiredChunks )
        {
            Debug.Log(
                $"Required Chunk: {coordinate}"
            );
        }
    }


    private Vector2Int GetPlayerChunk()
    {
        if (player == null)
            return Vector2Int.zero;

        return new Vector2Int(
            Mathf.FloorToInt((player.position.x + chunkSize * 0.5f) / chunkSize),
            Mathf.FloorToInt((player.position.z + chunkSize * 0.5f) / chunkSize)
        );
    }

    
}