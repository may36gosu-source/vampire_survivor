using UnityEngine;
using System;
using System.Collections;
public class MonsterController : Entity, IPoolable
{

    private Animator animator;
    private Transform player;

    private MonsterData monsterData;

    // private int currentHP; -- chuyển qua Entity

    // private bool isDead;

    public event Action<MonsterController> OnDead;

    private CapsuleCollider capsuleCollider;

    public void Initialize(MonsterData data)
    {
        monsterData = data;

        MaxHP = data.maxHP;
        currentHP = MaxHP;
        
        DisplayName = data.displayName;
    }

    public void OnSpawn()
    {
        currentHP = monsterData.maxHP;

        isDead = false;

        enabled = true;

        // characterController.enabled = true;

        if (capsuleCollider != null)
            capsuleCollider.enabled = true;

        // Rebind reset:

        // Trigger
        // Bool
        // Float
        // Layer Weight
        // State

        // gần như đưa Animator về trạng thái vừa mới Instantiate.    

        animator.Rebind();
        animator.Update(0f); // ép Animator cập nhật ngay trong frame hiện tại.

        animator.SetFloat("Speed", 0f);


    }

    public void OnDespawn()
    {
        enabled = false;

        if (capsuleCollider != null)
            capsuleCollider.enabled = false;
    }

    private void Awake()
    {
        base.Awake(); // tránh bị ghi đè
        PrepareComponents();
    }

    private void Start()
    {

    }

    private void Update()
    {
        Transform player = LocalPlayer.Transform;

        if (player == null)
            return;

        FollowPlayer(player);
    }

    public void TakeDamage(int damage)
    {
        if (isDead)
            return;

        currentHP = Mathf.Max(0, currentHP - damage);

        GameEvents.EntityDamaged(this);

        Debug.Log($"Monster HP : {currentHP}");

        if (currentHP == 0)
        {
            Dead();
        }
    }

    private void Dead()
    {
        if (isDead)
            return;

        isDead = true;
        GameEvents.EntityDead(this);


        StartCoroutine(DeadRoutine());
    }


    private IEnumerator DeadRoutine()
    {
        animator.SetFloat("Speed", 0f);
        animator.SetTrigger("Die");

        if (capsuleCollider != null)
            capsuleCollider.enabled = false;

        enabled = false;

        yield return null;

        while (true)
        {
            AnimatorStateInfo state =  animator.GetCurrentAnimatorStateInfo(0);

            if (state.IsName("Dying") && state.normalizedTime >= 1f)
            {
                break;
            }

            yield return null;
        }

        OnDead?.Invoke(this);

        DestroySelf();
    }

    private void DestroySelf()
    {
        // Destroy(gameObject); -- dùng pool thì không xóa
    }



    private void FollowPlayer(Transform player)
    {
        Vector3 direction = player.position - transform.position;
        direction.y = 0f;

        float distance = direction.magnitude;

        if (distance <= monsterData.detectRange)
        {
            animator.SetFloat("Speed", 0f);
            return;
        }

        direction.Normalize();

        Quaternion targetRotation = Quaternion.LookRotation(direction);

        transform.rotation = Quaternion.Slerp( transform.rotation, targetRotation, 10f * Time.deltaTime);

        animator.SetFloat("Speed", 1f);

        Move(direction);
    }


    private void Move(Vector3 direction)
    {
        transform.position +=  direction * monsterData.moveSpeed * Time.deltaTime;
    }



    private void PrepareComponents()
    {

        capsuleCollider = GetComponent<CapsuleCollider>();

        animator = GetComponent<Animator>();
    }
}