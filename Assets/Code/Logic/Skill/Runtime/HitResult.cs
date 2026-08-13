using UnityEngine;

public class HitResult
{
    public MonsterController Target { get; }

    public int Damage { get; }

    public Vector3 HitPoint { get; }

    public bool IsDead { get; }

    public HitResult(
        MonsterController target,
        int damage,
        Vector3 hitPoint,
        bool isDead)
    {
        Target = target;

        Damage = damage;

        HitPoint = hitPoint;

        IsDead = isDead;
    }
}