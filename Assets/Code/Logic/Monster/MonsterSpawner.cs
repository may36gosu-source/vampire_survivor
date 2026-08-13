
using System.Collections;
using UnityEngine;

public class MonsterSpawner : MonoBehaviour
{
    [Header("Wave")]
    [SerializeField]
    private WaveMonsterData waveData;

    [Header("Spawn")]
    [SerializeField]
    private Transform spawnRoot;

    [SerializeField]
    private float spawnRadius = 5f;

    [Header("Drop")]
    [SerializeField]
    private ExpData expData;

    private int currentAlive;

    private Coroutine respawnRoutine;

    private ObjectPool monsterPool;
    private ObjectPool expPool;

    //==================================================
    // Unity
    //==================================================

    private void Start()
    {
        monsterPool = new ObjectPool(waveData.monsterData.prefab, waveData.spawnCount, transform);

        expPool = new ObjectPool( expData.prefab, expData.preloadCount, transform);
    }

    private void OnEnable()
    {
        GameEvents.OnGameStarted += HandleGameStarted;
    }

    private void OnDisable()
    {
        GameEvents.OnGameStarted -= HandleGameStarted;
    }

    //==================================================
    // Game Start
    //==================================================

    private void HandleGameStarted()
    {
        SpawnWave();
    }

    private void SpawnWave()
    {
        for (int i = 0; i < waveData.spawnCount; i++)
        {
            SpawnMonster();
        }
    }

    //==================================================
    // Monster
    //==================================================

    private void SpawnMonster()
    {
        GameObject monster = monsterPool.Get();

        monster.transform.position = GetSpawnPosition();

        monster.transform.rotation = Quaternion.identity;

        MonsterController controller = monster.GetComponent<MonsterController>();

        if (controller == null)
        {
            controller = monster.AddComponent<MonsterController>();
        }

        // Initialize SAU KHI set position.
        controller.Initialize( waveData.monsterData);

        GameEvents.EntitySpawn( controller);

        controller.OnDead += HandleMonsterDead;

        currentAlive++;
    }

    //==================================================
    // Monster Death
    //==================================================

    private void HandleMonsterDead(MonsterController monster)
    {
        monster.OnDead -= HandleMonsterDead;

        currentAlive--;

        //==================================================
        // QUAN TRỌNG
        //
        // Không dùng:
        // monster.transform.position
        //
        // Vì Death Animation có thể thay đổi
        // vị trí visual/root.
        //==================================================

        SpawnExp( monster.DeathPosition);

        monsterPool.Release( monster.gameObject );

        if (respawnRoutine == null)
        {
            respawnRoutine = StartCoroutine( RespawnLoop());
        }
    }

    //==================================================
    // Respawn
    //==================================================

    private IEnumerator RespawnLoop()
    {
        while ( currentAlive < waveData.spawnCount )
        {
            yield return new WaitForSeconds( waveData.spawnInterval);

            int missing = waveData.spawnCount - currentAlive;

            int spawnAmount = Mathf.Min( missing, GameConst.MONSTER_MAX_SPAWN_PER_TICK);

            for ( int i = 0; i < spawnAmount; i++)
            {
                SpawnMonster();
            }
        }

        respawnRoutine = null;
    }

    //==================================================
    // Spawn Position
    //==================================================

    private Vector3 GetSpawnPosition()
    {
        Vector2 random = Random.insideUnitCircle * spawnRadius;

        return spawnRoot.position + new Vector3(random.x, 0f, random.y);
    }

    //==================================================
    // EXP
    //==================================================

    private void SpawnExp(Vector3 deathPosition)
    {
        GameObject exp = expPool.Get();

        // Lấy SphereCollider của Orb
        SphereCollider sphereCollider = exp.GetComponent<SphereCollider>();

        // Tìm Ground và raycast
        Vector3 spawnPosition = GetExpGroundPosition(deathPosition, sphereCollider);

        exp.transform.SetPositionAndRotation(spawnPosition, Quaternion.identity);

        ExpController controller = exp.GetComponent<ExpController>();

        if (controller == null)
        {
            controller = exp.AddComponent<ExpController>();
        }

        controller.Initialize(waveData.monsterData.expReward);

        controller.SetPool(expPool);
    }

    // private Vector3 GetExpGroundPosition(Vector3 position, SphereCollider sphereCollider)
    // {
    //     GameObject ground = GameObject.Find("Ground");

    //     if (ground == null)
    //     {
    //         Debug.LogError("MonsterSpawner: Không tìm thấy GameObject 'Ground'.");

    //         return position;
    //     }

    //     Collider groundCollider =
    //         ground.GetComponent<Collider>();

    //     if (groundCollider == null)
    //     {
    //         groundCollider = ground.GetComponentInChildren<Collider>();
    //     }

    //     if (groundCollider == null)
    //     {
    //         Debug.LogError( "MonsterSpawner: Ground không có Collider."   );

    //         return position;
    //     }

    //     Vector3 rayOrigin = position + Vector3.up * 2f;

    //     Ray ray = new Ray(rayOrigin, Vector3.down);

    //     if (groundCollider.Raycast( ray, out RaycastHit hit, 5f))
    //     {
    //         position.y = hit.point.y;

    //         // SphereCollider có tâm ở giữa Orb.
    //         // Đưa tâm lên đúng bán kính để Orb
    //         // nằm trên mặt đất.
    //         if (sphereCollider != null)
    //         {
    //             position.y += sphereCollider.bounds.extents.y;
    //         }
    //     }

    //     return position;
    // }

    private Vector3 GetExpGroundPosition(Vector3 position, SphereCollider sphereCollider)
    {
        if (GroundSystem.Instance == null)
            return position;

        if (GroundSystem.Instance.RaycastGround(position, out RaycastHit hit))
        {
            position.y = hit.point.y;

            if (sphereCollider != null)
                position.y += sphereCollider.bounds.extents.y;
        }

        return position;
    }
}