using UnityEngine;

[CreateAssetMenu(fileName = "MonsterData", menuName = "Game/Data/Monster Data")]
public class MonsterData : ScriptableObject
{
    public GameObject prefab;
    public int maxHP = 50;
    public int expReward = 10;
    public float moveSpeed = 2.5f;
    public int attack = 10;
    public float detectRange = 8f;
}