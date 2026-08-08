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
    
    public static event Action<MonsterController> OnMonsterDamaged;

    public static event Action<Entity> OnEntityDamaged;
    public static event Action<Entity> OnEntityDead;



    public static void MonsterDead(MonsterController monster)
    {
        OnMonsterDead?.Invoke(monster);
    }

    public static void MonsterDamaged(MonsterController monster)
    {
        OnMonsterDamaged?.Invoke(monster);
    }


    public static void EntityDamaged(Entity entity)
    {
        OnEntityDamaged?.Invoke(entity);
    }

    public static void EntityDead(Entity entity)
    {
        OnEntityDead?.Invoke(entity);
    }

    public static event Action<Entity> OnEntitySpawn;
    
    public static void EntitySpawn(Entity entity)
    {
        OnEntitySpawn?.Invoke(entity);
    }
}