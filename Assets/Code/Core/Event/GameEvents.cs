using System;

public static class GameEvents
{

    // ------------------------
    // Player
    // ------------------------
    public static event Action<int> OnExpCollected;

    public static event Action<int> OnLevelUp;

    public static void ExpCollected(int exp)
    {
        OnExpCollected?.Invoke(exp);
    }

    public static void LevelUp(int level)
    {
        OnLevelUp?.Invoke(level);
    }

    // ------------------------
    // Monster
    // ------------------------

    public static event Action<MonsterController> OnMonsterDead;

    public static void MonsterDead(MonsterController monster)
    {
        OnMonsterDead?.Invoke(monster);
    }
}