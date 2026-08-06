using System.Collections;
using UnityEngine;

public class MonsterSpawner : MonoBehaviour
{
    [Header("Wave")]
    [SerializeField] private WaveMonsterData waveData;

    [Header("Spawn")]
    [SerializeField] private Transform spawnRoot;
    [SerializeField] private float spawnRadius = 3f;

    private int currentAlive;

    // Chỉ cho phép một Coroutine Respawn chạy
    private Coroutine respawnRoutine;


    private ObjectPool monsterPool; // sử dụng pool

    private void Start()
    {
        
        monsterPool = new ObjectPool( waveData.monsterData.prefab, waveData.spawnCount, transform);

        SpawnWave();
    }

    /// <summary>
    /// Spawn toàn bộ Monster của Wave đầu tiên.
    /// </summary>
    private void SpawnWave()
    {
        for (int i = 0; i < waveData.spawnCount; i++)
        {
            SpawnMonster();
        }
    }

    /// <summary>
    /// Spawn một Monster.
    /// </summary>
    private void SpawnMonster()
    {
        // GameObject monster = Instantiate( waveData.monsterData.prefab, GetSpawnPosition(), Quaternion.identity); //-- cách cũ


        GameObject monster = monsterPool.Get();

        monster.transform.position = GetSpawnPosition();
        monster.transform.rotation = Quaternion.identity;

        // MonsterController controller = monster.AddComponent<MonsterController>(); // cách cũ chưa xài pool


        // ---- cách mới dùng pool thì controller chỉ set 1 lần
        MonsterController controller = monster.GetComponent<MonsterController>();

        if (controller == null)
        {
            controller = monster.AddComponent<MonsterController>();
        }


        controller.Initialize(waveData.monsterData);

        controller.OnDead += HandleMonsterDead;

        currentAlive++;
    }

    /// <summary>
    /// Monster chết.
    /// </summary>
    private void HandleMonsterDead(MonsterController monster)
    {
        monster.OnDead -= HandleMonsterDead;

        currentAlive--;

        SpawnExp(monster.transform.position);

        monsterPool.Release(monster.gameObject); // đưa về pool

        // Nếu đã có Coroutine rồi thì không tạo thêm
        if (respawnRoutine == null)
        {
            respawnRoutine = StartCoroutine(RespawnLoop());
        }
    }

    /// <summary>
    /// Luôn duy trì số lượng Monster của Wave.
    /// </summary>
    private IEnumerator RespawnLoop()
    {
        while (currentAlive < waveData.spawnCount)
        {
            yield return new WaitForSeconds( waveData.spawnInterval);

            int missing = waveData.spawnCount - currentAlive;

            int spawnAmount =  Mathf.Min(missing, GameConst.MONSTER_MAX_SPAWN_PER_TICK);

            for (int i = 0; i < spawnAmount; i++)
            {
                SpawnMonster();
            }
        }

        // Cho phép tạo Coroutine mới khi cần
        respawnRoutine = null;
    }

    /// <summary>
    /// Tính vị trí Spawn.
    /// Sau này chỉ cần sửa hàm này khi có Terrain / NavMesh.
    /// </summary>
    private Vector3 GetSpawnPosition()
    {
        Vector2 random = Random.insideUnitCircle * spawnRadius;

        return spawnRoot.position + new Vector3(random.x, 0f, random.y);
    }

    /// <summary>
    /// Spawn EXP.
    /// Prototype chỉ log.
    /// </summary>
    private void SpawnExp(Vector3 position)
    {
        Debug.Log($"Spawn EXP : {position}");
    }
}