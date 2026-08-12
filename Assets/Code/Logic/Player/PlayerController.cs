// using UnityEngine;

// public class PlayerController : Entity
// {
//     [SerializeField] private FixedJoystick joystick;
//     [SerializeField] private float moveSpeed;


//     #region ScriptableObject

//     /// <summary>
//     /// The ScriptableObject section
//     /// </summary>
    
//     [SerializeField] private PlayerData playerData;
//     #endregion

    

//     // private CharacterController controller;
//     private Animator animator;

//     private Vector3 moveDirection;


//     // Base ATTR
//     // private int currentHP;

//     private int currentLevel = 1;

//     private int currentAttack = 1;

//     // public int CurrentAttack => currentAttack;

//     private int currentExp = 0;

//     private int expToNextLevel = 100;

//     public int CurrentLevel => currentLevel;

//     public int CurrentAttack => currentAttack;

//     public int CurrentExp => currentExp;

//     public int ExpToNextLevel => expToNextLevel;


//     private void Awake()
//     {
//         // controller = GetComponent<CharacterController>();
//         base.Awake();
//         animator = GetComponent<Animator>();

//         DisplayName = "Player";

//         LocalPlayer.Register(this);

//         // GameEvents.EntitySpawn(this); // HUD

//         moveSpeed = playerData.moveSpeed; 

        

//         currentAttack = playerData.attack;

//         GameEvents.OnExpCollected += AddExp; // đăng ký sự kiện nhận exp
        
//         GameEvents.OnLevelUp += LevelUp; // đăng ký sự kiện nhận level up

//         MaxHP = playerData.maxHP;

//         currentHP = MaxHP;

//         Debug.Log($"HeadPoint.position======================== : {HeadPoint.position}");
//     }

//     private void Start()
//     {
//         GameEvents.EntitySpawn(this);
//     }

//     private void Update()
//     {
        

//         if (!GameStateHelper.IsPlaying())
//         return;

//         // Debug.Log(transform.position);
//         moveDirection = new Vector3(joystick.Horizontal, 0f, joystick.Vertical);

//         if (moveDirection.sqrMagnitude > 1f)
//         {
//             moveDirection.Normalize();
//         }

//         // controller.Move( moveDirection * moveSpeed * Time.deltaTime);

//         Move(moveDirection);

//         animator.SetFloat("Speed", moveDirection.magnitude); // set để đổi trạng thái idle => walk

//         if (moveDirection.sqrMagnitude > 0.01f)
//         {
//             transform.rotation = Quaternion.LookRotation(moveDirection); // xoay mặt cho đúng khi joystick
//         }
//     }

//     private void Move(Vector3 direction)
//     {
//         Vector3 delta = direction * moveSpeed * Time.deltaTime;

//         transform.position += delta;
//     }


//     private void AddExp(int exp)
//     {
//         currentExp += exp;

//         Debug.Log($"EXP : {currentExp}");

//         CheckLevelUp();
//     }

//     private void CheckLevelUp()
//     {
//         while(currentExp >= expToNextLevel)
//         {
//             currentExp -= expToNextLevel;

//             currentLevel++;

//             currentAttack += 5;

//             expToNextLevel += 50;

//             GameEvents.LevelUp(currentLevel);
//         }
//     }

//     private void LevelUp(int level)
//     {
       

//         Debug.Log($"LEVEL UP======================== : {level}");

//     }
//     private void OnDestroy()
//     {
//         LocalPlayer.Unregister(this);
//         GameEvents.OnExpCollected -= AddExp;
//         GameEvents.OnLevelUp -= LevelUp;
//     }

// }


using UnityEngine;
using System.Collections;

public class PlayerController : Entity
{
    [SerializeField] private FixedJoystick joystick;
    [SerializeField] private float moveSpeed;

    #region ScriptableObject

    [SerializeField] private PlayerData playerData;

    #endregion

    private Animator animator;
    private Rigidbody rb;

    private Vector3 moveDirection;

    private int currentLevel = 1;
    private int currentAttack = 1;
    private int currentExp = 0;
    private int expToNextLevel = 100;

    public int CurrentLevel => currentLevel;
    public int CurrentAttack => currentAttack;
    public int CurrentExp => currentExp;
    public int ExpToNextLevel => expToNextLevel;

    private CapsuleCollider capsuleCollider;

    private void Awake()
    {
        base.Awake();

        capsuleCollider = GetComponentInChildren<CapsuleCollider>(true);

        animator = GetComponent<Animator>();
        rb = GetComponent<Rigidbody>();

        DisplayName = "Player";

        LocalPlayer.Register(this);

        moveSpeed = playerData.moveSpeed;
        currentAttack = playerData.attack;

        GameEvents.OnExpCollected += AddExp;
        GameEvents.OnLevelUp += LevelUp;

        MaxHP = playerData.maxHP;
        currentHP = MaxHP;
    }

    private void Start()
    {
        GameEvents.EntitySpawn(this);
    }

    private void Update()
    {
        if (!GameStateHelper.IsPlaying())
        {
            moveDirection = Vector3.zero;

            animator.SetFloat("Speed", 0f);

            return;
        }

        ReadMovementInput();

        UpdateAnimation();

        UpdateRotation();
    }

    private void FixedUpdate()
    {
        if (!GameStateHelper.IsPlaying())
        {
            StopMovement();
            return;
        }

        Move(moveDirection);
    }

    private void ReadMovementInput()
    {
        moveDirection = new Vector3(joystick.Horizontal, 0f, joystick.Vertical);

        if (moveDirection.sqrMagnitude > 1f)
        {
            moveDirection.Normalize();
        }
    }

    private void Move(Vector3 direction)
    {
        Vector3 velocity = direction * moveSpeed;

        // Không can thiệp vào Y.
        // Y để Rigidbody + Gravity xử lý.
        velocity.y = rb.linearVelocity.y;

        rb.linearVelocity = velocity;
    }

    private void StopMovement()
    {
        Vector3 velocity = rb.linearVelocity;

        velocity.x = 0f;
        velocity.z = 0f;

        rb.linearVelocity = velocity;
    }

    private void UpdateAnimation()
    {
        animator.SetFloat("Speed", moveDirection.magnitude);
    }

    private void UpdateRotation()
    {
        if (moveDirection.sqrMagnitude <= 0.01f)
            return;

        transform.rotation = Quaternion.LookRotation(moveDirection);
    }

    private void AddExp(int exp)
    {
        currentExp += exp;

        // Debug.Log($"EXP : {currentExp}");

        CheckLevelUp();
    }

    private void CheckLevelUp()
    {
        while (currentExp >= expToNextLevel)
        {
            currentExp -= expToNextLevel;

            currentLevel++;

            currentAttack += 5;

            expToNextLevel += 50;

            GameEvents.LevelUp(currentLevel);
        }
    }

    private void LevelUp(int level)
    {
        // Debug.Log( $"LEVEL UP======================== : {level}");
    }

    private void OnDestroy()
    {
        LocalPlayer.Unregister(this);

        GameEvents.OnExpCollected -= AddExp;
        GameEvents.OnLevelUp -= LevelUp;
    }

    public void TakeDamage(int damage)
    {
        if (damage <= 0)
        return;

        if (isDead)
            return;


        Vector3 hitPosition = HeadPoint.position;

        Vector3 hitDirection = Forward;

        currentHP = Mathf.Max(0, currentHP - damage);


        GameEvents.EntityDamaged(this);

        // Debug.Log($"Player HP : {currentHP}");

        GameEvents.PopupDamage(hitPosition, hitDirection, damage);


        if (currentHP <= 0)
        {
            Die();
        }
    }

    private void Die()
    {
        if (isDead)
            return;

        isDead = true;

        Debug.Log("PLAYER DEAD");

        StopMovement();

        GameEvents.EntityDead(this);

        StartCoroutine( DeadRoutine());
    }

    private IEnumerator DeadRoutine()
    {
        // ========================================
        // STOP MOVEMENT ANIMATION
        // ========================================

        animator.SetFloat(GameConst.ANIM_SPEED, 0f);


        // ========================================
        // PLAY DEATH ANIMATION
        // ========================================

        animator.SetTrigger(GameConst.ANIM_DEAD);


        // ========================================
        // DISABLE COLLIDER
        // ========================================

        if (capsuleCollider != null)
        {
            capsuleCollider.enabled = false;
        }

        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
        rb.isKinematic = true;


        // ========================================
        // STOP PLAYER CONTROLLER
        // ========================================

        enabled = false;


        // Cho Animator chuyển state
        yield return null;


        // ========================================
        // WAIT DEATH ANIMATION END
        // ========================================

        while (true)
        {
            AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);


            if (state.IsTag( GameConst.ANIM_TAG_DEAD ) && state.normalizedTime >= 1f)
            {
                break;
            }


            yield return null;
        }


        Debug.Log("PLAYER DEATH ANIMATION FINISHED");


        // ========================================
        // GAME OVER
        // ========================================

        GameManager.Instance.GameOver();
    }


    

}