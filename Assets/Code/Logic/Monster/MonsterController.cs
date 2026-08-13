//==================================================================================================================
// 
//  V1, no Rigidbody, transform move
//
//==================================================================================================================

// using UnityEngine;
// using System;
// using System.Collections;
// public class MonsterController : Entity, IPoolable
// {

//     private Animator animator;
//     private Transform player;

//     private MonsterData monsterData;

//     // private int currentHP; -- chuyển qua Entity

//     // private bool isDead;

//     public event Action<MonsterController> OnDead;

//     private CapsuleCollider capsuleCollider;

//     public void Initialize(MonsterData data)
//     {
//         monsterData = data;

//         MaxHP = data.maxHP;
//         currentHP = MaxHP;
        
//         DisplayName = data.displayName;
//     }

//     public void OnSpawn()
//     {
//         currentHP = monsterData.maxHP;

//         isDead = false;

//         enabled = true;

//         if (capsuleCollider != null)
//             capsuleCollider.enabled = true;

//         // Rebind reset:
//         // Trigger
//         // Bool
//         // Float
//         // Layer Weight
//         // State

//         // gần như đưa Animator về trạng thái vừa mới Instantiate.    

//         animator.Rebind();
//         animator.Update(0f); // ép Animator cập nhật ngay trong frame hiện tại.

//         animator.SetFloat("Speed", 0f);


//     }

//     public void OnDespawn()
//     {
//         enabled = false;

//         if (capsuleCollider != null)
//             capsuleCollider.enabled = false;
//     }

//     private void Awake()
//     {
//         base.Awake(); // tránh bị ghi đè
//         PrepareComponents();
//     }

//     private void Start()
//     {

//     }

//     private void Update()
//     {
//         Transform player = LocalPlayer.Transform;

//         if (!GameStateHelper.IsPlaying())
//         return;

//         if (player == null)
//             return;

//         FollowPlayer(player);
//     }

//     public void TakeDamage(int damage)
//     {
//         if (isDead)
//             return;

//         Vector3 hitPosition = HeadPoint.position;
//         Vector3 hitDirection = Forward;

//         currentHP = Mathf.Max(0, currentHP - damage);

//         GameEvents.EntityDamaged(this);

//         GameEvents.PopupDamage(hitPosition, hitDirection, damage);

//         Debug.Log($"Monster HP : {currentHP}");

//         if (currentHP == 0)
//         {
//             Dead();
//         }
//     }

//     private void Dead()
//     {
//         if (isDead)
//             return;

//         isDead = true;
//         GameEvents.EntityDead(this);


//         StartCoroutine(DeadRoutine());
//     }


//     private IEnumerator DeadRoutine()
//     {
//         animator.SetFloat("Speed", 0f);
//         animator.SetTrigger("Die");

//         if (capsuleCollider != null)
//             capsuleCollider.enabled = false;

//         enabled = false;

//         yield return null;

//         while (true)
//         {
//             AnimatorStateInfo state =  animator.GetCurrentAnimatorStateInfo(0);

//             if (state.IsName("Dying") && state.normalizedTime >= 1f)
//             {
//                 break;
//             }

//             yield return null;
//         }

//         OnDead?.Invoke(this);

//         DestroySelf();
//     }

//     private void DestroySelf()
//     {
//         // Destroy(gameObject); -- dùng pool thì không xóa
//     }



//     private void FollowPlayer(Transform player)
//     {
//         Vector3 direction = player.position - transform.position;
//         direction.y = 0f;

//         float distance = direction.magnitude;

//         if (distance <= monsterData.detectRange)
//         {
//             animator.SetFloat("Speed", 0f);
//             return;
//         }

//         direction.Normalize();

//         Quaternion targetRotation = Quaternion.LookRotation(direction);

//         transform.rotation = Quaternion.Slerp( transform.rotation, targetRotation, 10f * Time.deltaTime);

//         animator.SetFloat("Speed", 1f);

//         Move(direction);
//     }


//     private void Move(Vector3 direction)
//     {
//         transform.position +=  direction * monsterData.moveSpeed * Time.deltaTime;
//     }

//     private void PrepareComponents()
//     {

//         capsuleCollider = GetComponent<CapsuleCollider>();

//         animator = GetComponent<Animator>();
//     }
// }


//==================================================================================================================
// 
//  V2, Rigidbody
//
//==================================================================================================================

using UnityEngine;
using System;
using System.Collections;

// public class MonsterController : Entity, IPoolable
// {
//     private Animator animator;
//     private Transform player;

//     private MonsterData monsterData;

//     public event Action<MonsterController> OnDead;

//     private CapsuleCollider capsuleCollider;
//     private Rigidbody rb;

//     public void Initialize(MonsterData data)
//     {
//         monsterData = data;

//         MaxHP = data.maxHP;
//         currentHP = MaxHP;

//         DisplayName = data.displayName;
//     }

//     public void OnSpawn()
//     {
//         currentHP = monsterData.maxHP;

//         isDead = false;

//         enabled = true;

//         // Reset Rigidbody
//         rb.isKinematic = false;
//         rb.velocity = Vector3.zero;
//         rb.angularVelocity = Vector3.zero;

//         if (capsuleCollider != null)
//             capsuleCollider.enabled = true;

//         animator.Rebind();
//         animator.Update(0f);

//         animator.SetFloat("Speed", 0f);
//     }

//     public void OnDespawn()
//     {
//         enabled = false;

//         rb.velocity = Vector3.zero;
//         rb.angularVelocity = Vector3.zero;

//         rb.isKinematic = false;

//         if (capsuleCollider != null)
//             capsuleCollider.enabled = false;
//     }

//     private void Awake()
//     {
//         base.Awake();

//         PrepareComponents();
//     }

//     private void FixedUpdate()
//     {
//         if (!GameStateHelper.IsPlaying())
//             return;

//         player = LocalPlayer.Transform;

//         if (player == null)
//             return;

//         // Monster không bị collision tự xoay
//         rb.angularVelocity = Vector3.zero;

//         FollowPlayer(player);
//     }

//     public void TakeDamage(int damage)
//     {
//         if (isDead)
//             return;

//         Vector3 hitPosition = HeadPoint.position;
//         Vector3 hitDirection = Forward;

//         currentHP = Mathf.Max( 0, currentHP - damage );

//         GameEvents.EntityDamaged(this);

//         GameEvents.PopupDamage(hitPosition, hitDirection, damage);

//         Debug.Log($"Monster HP : {currentHP}");

//         if (currentHP == 0)
//         {
//             Dead();
//         }
//     }

//     private void Dead()
//     {
//         if (isDead)
//             return;

//         isDead = true;

//         GameEvents.EntityDead(this);

//         StartCoroutine(DeadRoutine());
//     }

//     private IEnumerator DeadRoutine()
//     {
//         animator.SetFloat("Speed", 0f);
//         animator.SetTrigger("Die");

//         // Dừng mọi chuyển động Physics
//         rb.velocity = Vector3.zero;
//         rb.angularVelocity = Vector3.zero;

//         // Không cho Gravity tiếp tục kéo Monster xuống
//         rb.isKinematic = true;

//         // Không cho tiếp tục va chạm
//         if (capsuleCollider != null)
//             capsuleCollider.enabled = false;

//         enabled = false;

//         yield return null;

//         while (true)
//         {
//             AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

//             if (state.IsName("Dying") && state.normalizedTime >= 1f)
//             {
//                 break;
//             }

//             yield return null;
//         }

//         OnDead?.Invoke(this);

//         DestroySelf();
//     }

//     private void DestroySelf()
//     {
//         // Pool sẽ xử lý Release.
//     }

//     private void FollowPlayer(Transform player)
//     {
//         Vector3 direction = player.position - rb.position;

//         direction.y = 0f;

//         float distance = direction.magnitude;

//         if (distance <= monsterData.detectRange)
//         {
//             animator.SetFloat("Speed", 0f);

//             return;
//         }

//         direction.Normalize();

//         Quaternion targetRotation = Quaternion.LookRotation(direction);

//         Quaternion newRotation = Quaternion.Slerp( rb.rotation, targetRotation, 10f * Time.fixedDeltaTime );

//         rb.MoveRotation(newRotation);

//         animator.SetFloat("Speed", 1f);

//         Move(direction);
//     }

//     private void Move(Vector3 direction)
//     {
//         Vector3 nextPosition =
//             rb.position +
//             direction *
//             monsterData.moveSpeed *
//             Time.fixedDeltaTime;

//         rb.MovePosition(nextPosition);
//     }

//     private void PrepareComponents()
//     {
//         rb = GetComponent<Rigidbody>();

//         capsuleCollider = GetComponent<CapsuleCollider>();

//         animator =  GetComponent<Animator>();
//     }
// }


//==================================================================================================================
// 
//  V3, New Monster
//
//==================================================================================================================

using System;
using System.Collections;
using UnityEngine;

public class MonsterController : Entity, IPoolable
{
    private Animator animator;
    private Transform player;

    private MonsterData monsterData;

    public event Action<MonsterController> OnDead;

    private CapsuleCollider capsuleCollider;

    //==================================================
    // Ground
    //==================================================

    [Header("Ground")]
    [SerializeField]
    private float groundRayHeight = 2f;

    [SerializeField]
    private float groundRayDistance = 5f;

    private Collider groundCollider;

    //==================================================
    // Movement Animation
    //==================================================

    [Header("Movement Animation")]
    [SerializeField]
    private float runSpeedThreshold = 3f;

    //==================================================
    // Death
    //==================================================

    private Vector3 deathPosition;

    public Vector3 DeathPosition => deathPosition;

    //==================================================
    // Initialize
    //==================================================


    private Collider monsterCollider;
    private Collider playerCollider;

    private bool isAttacking;

    private float attackTimer;

    private Coroutine attackRoutine;

    public void Initialize(MonsterData data)
    {
        monsterData = data;

        MaxHP = data.maxHP;
        currentHP = MaxHP;

        DisplayName = data.displayName;

        // Quan trọng:
        // Initialize được gọi SAU khi Spawner đã set position.
        // Vì vậy SnapToGround ở đây mới đúng.

        IgnorePlayerCollision();

        SnapToGround();
    }

    //==================================================
    // Pool
    //==================================================


    public void OnSpawn()
    {
        isDead = false;

        enabled = true;

        isAttacking = false;
        attackTimer = 0f;
        attackRoutine = null;

        player = LocalPlayer.Transform;

        if (capsuleCollider != null)
            capsuleCollider.enabled = true;

        animator.Rebind();
        animator.Update(0f);

        animator.SetFloat(GameConst.ANIM_SPEED, 0f);

        if (monsterData != null)
        {
            currentHP = monsterData.maxHP;
        }
    }

   

    public void OnDespawn()
    {
        enabled = false;

        if (capsuleCollider != null)
            capsuleCollider.enabled = false;

        player = null;

        isAttacking = false;
        attackTimer = 0f;
        attackRoutine = null;
    }

    //==================================================
    // Unity
    //==================================================

    private void Awake()
    {
        base.Awake();

        PrepareComponents();
    }

    private void OnEnable()
    {
        GameEvents.OnEntityDead += HandleEntityDead;
    }

    private void OnDisable()
    {
        GameEvents.OnEntityDead -= HandleEntityDead;
    }

    private void HandleEntityDead(Entity entity)
    {
        if (entity is not PlayerController target)
        return;

        if (player == null)
            return;

        float distance = Vector3.Distance(transform.position, target.transform.position);

        // Chỉ Monster đang nằm trong snapshot/detect range
        // mới phản ứng.
        if (distance > monsterData.detectRange)
            return;

        CancelAttack();

     

        // Đưa Animator về Idle
        animator.SetFloat(GameConst.ANIM_SPEED, 0f);

        animator.Play(GameConst.ANIM_IDLE, 0, 0f);
    }

    private void CancelAttack()
    {
        if (attackRoutine != null)
        {
            StopCoroutine(attackRoutine);
            attackRoutine = null;
        }

        isAttacking = false;

        attackTimer = 0f;

        animator.ResetTrigger(GameConst.ANIM_ATTACK);

        animator.SetFloat(GameConst.ANIM_SPEED, 0f );
    }



    private void Update()
    {
        if (!GameStateHelper.IsPlaying())
            return;

        player = LocalPlayer.Transform;

        if (player == null)
            return;

        // Player đã chết → Monster không làm AI nữa
        if (LocalPlayer.Instance.IsDead)
            return;

        UpdateAttackTimer();

        if (isAttacking)
            return;

        FollowPlayer(player);
    }


    private void UpdateAttackTimer()
    {
        if (attackTimer <= 0f)
            return;

        attackTimer -= Time.deltaTime;

        if (attackTimer < 0f)
            attackTimer = 0f;
    }

    //==================================================
    // Damage
    //==================================================

    public void TakeDamage(int damage)
    {
        if (isDead)
            return;

        Vector3 hitPosition = HeadPoint.position;

        Vector3 hitDirection = Forward;

        currentHP = Mathf.Max(0, currentHP - damage);

        GameEvents.EntityDamaged(this);

        GameEvents.PopupDamage(hitPosition, hitDirection, damage);

        // Debug.Log($"Monster HP : {currentHP}");

        if (currentHP == 0)
        {
            Dead();
        }
    }

    //==================================================
    // Death
    //==================================================

   

    private void Dead()
    {
        if (isDead)
            return;

        isDead = true;

        if (attackRoutine != null)
        {
            StopCoroutine(attackRoutine);

            attackRoutine = null;
        }

        isAttacking = false;

        deathPosition = transform.position;

        deathPosition.y = GetGroundY(deathPosition);

        GameEvents.EntityDead(this);

        StartCoroutine(DeadRoutine());
    }


    private IEnumerator DeadRoutine()
    {
        animator.SetFloat(GameConst.ANIM_SPEED, 0f);

        animator.SetTrigger(GameConst.ANIM_DEAD);

        if (capsuleCollider != null)
            capsuleCollider.enabled = false;

        // Dừng AI
        enabled = false;

        // Chờ Animator chuyển sang Death state.
        yield return null;

        while (true)
        {
            AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

            if (state.IsTag(GameConst.ANIM_TAG_DEAD) && state.normalizedTime >= 1f)
            {
                break;
            }

            yield return null;
        }

        OnDead?.Invoke(this);

    }


    //==================================================
    // Movement Animation
    //==================================================

    private void UpdateMovementAnimation()
    {
        float animationSpeed = monsterData.moveSpeed >= runSpeedThreshold ? 2f : 1f;

        animator.SetFloat(GameConst.ANIM_SPEED, animationSpeed);

        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);



        // AnimatorStateInfo nextState =
        // animator.GetNextAnimatorStateInfo(0);

        // Debug.Log(
        //     $"[{name}] " +
        //     $"Speed={animator.GetFloat(GameConst.ANIM_SPEED)} | " +
        //     $"Current={state.shortNameHash} | " +
        //     $"Idle={state.IsName("Idle")} | " +
        //     $"Walk={state.IsName("Monster07_Walk")} | " +
        //     $"Run={state.IsName("Monster07_Run")} | " +
        //     $"InTransition={animator.IsInTransition(0)} | " +
        //     $"Next={nextState.shortNameHash}"
        // );
    }

    //==================================================
    // AI
    //==================================================

    

    private void FollowPlayer(Transform target)
    {
        if (isDead)
            return;

        Vector3 direction = target.position - transform.position;

        direction.y = 0f;

        float distance = direction.magnitude;

        // ========================================
        // PLAYER TRONG ATTACK RANGE
        // ========================================

        if (distance <= monsterData.attackRange)
        {
            StopMovement();

            FacePlayer(direction);

            TryAttack();

            return;
        }

        // ========================================
        // PLAYER Ở XA
        // ========================================

        if (direction.sqrMagnitude <= 0.001f)
        {
            StopMovement();
            return;
        }

        direction.Normalize();

        FacePlayer(direction);

        UpdateMovementAnimation();

        Move(direction);
    }

    


    private void Move(Vector3 direction)
    {
        Vector3 position = transform.position + direction * monsterData.moveSpeed * Time.deltaTime;

        // X/Z do AI quyết định.
        // Y do Ground quyết định.
        position.y = GetGroundY(position);

        transform.position = position;
    }

    //==================================================
    // Ground
    //==================================================

    private Collider GetGroundCollider()
    {
        if (groundCollider != null)
            return groundCollider;

        GameObject ground = GameObject.Find("Ground");

        if (ground == null)
        {
            Debug.LogError( "MonsterController: Không tìm thấy GameObject 'Ground'.");

            return null;
        }

        groundCollider = ground.GetComponent<Collider>();

        if (groundCollider == null)
        {
            groundCollider = ground.GetComponentInChildren<Collider>();
        }

        if (groundCollider == null)
        {
            Debug.LogError("MonsterController: Ground không có Collider.");
        }

        return groundCollider;
    }

    // private float GetGroundY(Vector3 position)
    // {
    //     Collider ground = GetGroundCollider();

    //     if (ground == null)
    //         return position.y;

    //     Vector3 rayOrigin = position + Vector3.up * groundRayHeight;

    //     Ray ray = new Ray(rayOrigin, Vector3.down);

    //     if (ground.Raycast(ray, out RaycastHit hit, groundRayDistance))
    //     {
    //         return hit.point.y;
    //     }

    //     // Không tìm thấy Ground
    //     // giữ nguyên Y hiện tại.
    //     return position.y;
    // }


    private float GetGroundY(Vector3 position)
    {
        if (GroundSystem.Instance == null)
            return position.y;

        return GroundSystem.Instance.GetGroundY(position);
    }


    private void SnapToGround()
    {
        Vector3 position = transform.position;

        position.y = GetGroundY(position);

        transform.position = position;
    }

    //==================================================
    // Components
    //==================================================

    private void PrepareComponents()
    {
        capsuleCollider = GetComponentInChildren<CapsuleCollider>(true);

        animator = GetComponentInChildren<Animator>(true);


        monsterCollider = GetComponentInChildren<CapsuleCollider>(true);

        playerCollider = LocalPlayer.Transform?.GetComponent<Collider>();
    }

    private void IgnorePlayerCollision()
    {
        if (monsterCollider == null)
            return;

        Transform player = LocalPlayer.Transform;

        if (player == null)
            return;

        Collider playerCollider = player.GetComponent<Collider>();

        if (playerCollider == null)
            return;

        Physics.IgnoreCollision( monsterCollider, playerCollider, true );
    }


    private void StopMovement()
    {
        animator.SetFloat( GameConst.ANIM_SPEED, 0f);
    }

    private void FacePlayer(Vector3 direction)
    {
        if (direction.sqrMagnitude <= 0.001f)
            return;

        Quaternion targetRotation = Quaternion.LookRotation(direction);

        transform.rotation = Quaternion.Slerp(transform.rotation, targetRotation, 10f * Time.deltaTime);
    }

    private void TryAttack()
    {
        if (isAttacking)
            return;

        if (attackTimer > 0f)
            return;

        attackRoutine = StartCoroutine(AttackRoutine());
    }


    private IEnumerator AttackRoutine()
    {
        
        // Monster chết
        if (isDead)
            yield break;

        // Game không còn Playing
        if (!GameStateHelper.IsPlaying())
            yield break;

        // Player không còn hợp lệ
        if (LocalPlayer.Instance == null)
            yield break;

        if (LocalPlayer.Instance.IsDead)
            yield break;

        isAttacking = true;

        // Cooldown bắt đầu ngay khi Monster ra đòn.
        attackTimer = monsterData.attackCooldown;

        animator.SetFloat(GameConst.ANIM_SPEED, 0f);

        animator.SetTrigger(GameConst.ANIM_ATTACK);


        // ========================================
        // WAIT ATTACK STATE
        // ========================================

        yield return null;

        while (true)
        {
            if (!GameStateHelper.IsPlaying())
                yield break;

            if (isDead)
                yield break;

            if (LocalPlayer.Instance == null)
                yield break;

            if (LocalPlayer.Instance.IsDead)
                yield break;



            AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);


            if (state.IsTag(
                GameConst.ANIM_TAG_ATTACK
            ))
            {
                break;
            }


            yield return null;
        }


        // ========================================
        // WAIT HIT TIME
        // ========================================

        while (true)
        {
            if (!GameStateHelper.IsPlaying())
                yield break;

            if (isDead)
                yield break;

            if (LocalPlayer.Instance == null)
                yield break;

            if (LocalPlayer.Instance.IsDead)
                yield break;


            AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);


            if (state.IsTag(GameConst.ANIM_TAG_ATTACK) && state.normalizedTime >= monsterData.attackHitTime)
            {
                PerformAttack();

                break;
            }


            yield return null;
        }


        // ========================================
        // WAIT ATTACK END
        // ========================================

        while (true)
        {
            if (!GameStateHelper.IsPlaying())
                yield break;

            if (isDead)
                yield break;


            AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);


            if (state.IsTag(GameConst.ANIM_TAG_ATTACK) && state.normalizedTime >= 1f)
            {
                break;
            }


            yield return null;
        }


        isAttacking = false;
        attackRoutine = null;
    }


    private void PerformAttack()
    {
        if (isDead)
            return;
        if (!GameStateHelper.IsPlaying())
        return;

        if (player == null)
            return;

        Vector3 direction = player.position - transform.position;

        direction.y = 0f;

        float distance = direction.magnitude;

        // Player đã chạy khỏi range
        // trước khi hit xảy ra.
        if (distance > monsterData.attackRange)
            return;

        PlayerController target = player.GetComponent<PlayerController>();

        if (target == null)
            return;

        target.TakeDamage(monsterData.attack);
    }
}