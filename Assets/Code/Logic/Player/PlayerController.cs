using UnityEngine;

public class PlayerController : Entity
{
    [SerializeField] private FixedJoystick joystick;
    [SerializeField] private float moveSpeed;


    #region ScriptableObject

    /// <summary>
    /// The ScriptableObject section
    /// </summary>
    
    [SerializeField] private PlayerData playerData;
    #endregion

    

    // private CharacterController controller;
    private Animator animator;

    private Vector3 moveDirection;


    // Base ATTR
    // private int currentHP;

    private int currentLevel = 1;

    private int currentAttack = 1;

    // public int CurrentAttack => currentAttack;

    private int currentExp = 0;

    private int expToNextLevel = 100;

    public int CurrentLevel => currentLevel;

    public int CurrentAttack => currentAttack;

    public int CurrentExp => currentExp;

    public int ExpToNextLevel => expToNextLevel;


    private void Awake()
    {
        // controller = GetComponent<CharacterController>();
        base.Awake();
        animator = GetComponent<Animator>();

        DisplayName = "Player";

        LocalPlayer.Register(this);

        // GameEvents.EntitySpawn(this); // HUD

        moveSpeed = playerData.moveSpeed; 

        

        currentAttack = playerData.attack;

        GameEvents.OnExpCollected += AddExp; // đăng ký sự kiện nhận exp
        
        GameEvents.OnLevelUp += LevelUp; // đăng ký sự kiện nhận level up

        MaxHP = playerData.maxHP;

        currentHP = MaxHP;

        Debug.Log($"HeadPoint.position======================== : {HeadPoint.position}");
    }

    private void Start()
    {
        GameEvents.EntitySpawn(this);
    }

    private void Update()
    {
        

        if (!GameStateHelper.IsPlaying())
        return;

        // Debug.Log(transform.position);
        moveDirection = new Vector3(joystick.Horizontal, 0f, joystick.Vertical);

        if (moveDirection.sqrMagnitude > 1f)
        {
            moveDirection.Normalize();
        }

        // controller.Move( moveDirection * moveSpeed * Time.deltaTime);

        Move(moveDirection);

        animator.SetFloat("Speed", moveDirection.magnitude); // set để đổi trạng thái idle => walk

        if (moveDirection.sqrMagnitude > 0.01f)
        {
            transform.rotation = Quaternion.LookRotation(moveDirection); // xoay mặt cho đúng khi joystick
        }
    }

    private void Move(Vector3 direction)
    {
        Vector3 delta = direction * moveSpeed * Time.deltaTime;

        transform.position += delta;
    }


    private void AddExp(int exp)
    {
        currentExp += exp;

        Debug.Log($"EXP : {currentExp}");

        CheckLevelUp();
    }

    private void CheckLevelUp()
    {
        while(currentExp >= expToNextLevel)
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
       

        Debug.Log($"LEVEL UP======================== : {level}");

    }
    private void OnDestroy()
    {
        LocalPlayer.Unregister(this);
        GameEvents.OnExpCollected -= AddExp;
        GameEvents.OnLevelUp -= LevelUp;
    }

}