using UnityEngine;

[CreateAssetMenu(fileName = "MonsterData", menuName = "Game/Data/Monster Data")]
public class MonsterData : ScriptableObject
{
    [Header("Identity")]
    public string displayName = "Slime";
    public GameObject prefab;

    [Header("Stats")]
    public int maxHP = 50;
    public int expReward = 10;
    public float moveSpeed = 2.5f;
    public int attack = 10;
    public float detectRange = 8f;
}