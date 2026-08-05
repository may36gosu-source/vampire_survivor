using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private FixedJoystick joystick;
    [SerializeField] private float moveSpeed;


    #region ScriptableObject

    /// <summary>
    /// The ScriptableObject section
    /// </summary>
    
    [SerializeField] private PlayerData playerData;
    #endregion

    

    private CharacterController controller;
    private Animator animator;

    private Vector3 moveDirection;


    // Base ATTR
    private int currentHP;

    private int currentLevel = 1;

    private int currentExp = 0;

    private int expToNextLevel = 100;


    private void Awake()
    {
        controller = GetComponent<CharacterController>();
        animator = GetComponent<Animator>();

        // Debug.Log(playerData.maxHP);
        // Debug.Log(playerData.attack);
        // Debug.Log(playerData.moveSpeed);

        moveSpeed = playerData.moveSpeed; 

        currentHP = playerData.maxHP;
    }

    private void Update()
    {
        // Debug.Log(transform.position);
        moveDirection = new Vector3(joystick.Horizontal, 0f, joystick.Vertical);

        if (moveDirection.sqrMagnitude > 1f)
        {
            moveDirection.Normalize();
        }

        controller.Move( moveDirection * moveSpeed * Time.deltaTime);

        animator.SetFloat("Speed", moveDirection.magnitude); // set để đổi trạng thái idle => walk

        if (moveDirection.sqrMagnitude > 0.01f)
        {
            transform.rotation = Quaternion.LookRotation(moveDirection); // xoay mặt cho đúng khi joystick
        }
    }
}