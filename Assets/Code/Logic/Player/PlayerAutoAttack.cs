using UnityEngine;

public class PlayerAutoAttack : MonoBehaviour
{
    [SerializeField] private PlayerData playerData;

    private float attackTimer;

    private PlayerController playerController;

    private void Awake()
    {
        playerController = GetComponent<PlayerController>();
    }

    private void Update()
    {
        attackTimer += Time.deltaTime;

        if (attackTimer < playerData.attackCooldown)
            return;

        MonsterController target = FindNearestMonster();

        if (target == null)
            return;

        attackTimer = 0f;

        // target.TakeDamage(playerData.attack);

        target.TakeDamage(playerController.CurrentAttack);

        Debug.Log($"Attack Monster - Damage: {playerController.CurrentAttack}");

        Debug.Log("Attack Monster");
    }

    private MonsterController FindNearestMonster()
    {
        Collider[] hits = Physics.OverlapSphere(transform.position, playerData.attackRange);

        foreach (Collider hit in hits)
        {
            // MonsterController monster = hit.GetComponent<MonsterController>();

            MonsterController monster = hit.GetComponentInParent<MonsterController>();

            if (monster != null)
                return monster;
        }

        return null;
    }

#if UNITY_EDITOR
    private void OnDrawGizmosSelected()
    {
        if (playerData == null)
            return;

        Gizmos.color = Color.red;

        Gizmos.DrawWireSphere(transform.position, playerData.attackRange);
    }
#endif
}