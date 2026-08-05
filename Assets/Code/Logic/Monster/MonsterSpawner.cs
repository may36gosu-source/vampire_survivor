using UnityEngine;

public class MonsterSpawner : MonoBehaviour
{
    [SerializeField] private WaveMonsterData waveData;
    [SerializeField] private Transform spawnPoint;

    private void Start()
    {
        SpawnMonster();
    }

    private void SpawnMonster()
    {
        // Instantiate(waveData.monsterData.prefab, spawnPoint.position, Quaternion.identity);

        GameObject monster = Instantiate(waveData.monsterData.prefab, spawnPoint.position, Quaternion.identity);

        MonsterController controller =  monster.AddComponent<MonsterController>();

        controller.Initialize(waveData.monsterData);

    }
}