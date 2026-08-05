using UnityEngine;

public class MonsterController : MonoBehaviour
{
    private CharacterController characterController;
    private Animator animator;
    private Transform player;

    private MonsterData monsterData;

    public void Initialize(MonsterData data)
    {
        monsterData = data;
    }

    private void Awake()
    {
        PrepareComponents();
    }

    private void Start()
    {
        GameObject playerObject = GameObject.FindWithTag("Player");

        if (playerObject == null)
        {
            Debug.LogError("Không tìm thấy Player trong Scene!");
            return;
        }

        player = playerObject.transform;
    }

    private void Update()
    {
        if (player == null)
        return;

        FollowPlayer();
    }

    private void FollowPlayer()
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

        transform.rotation = Quaternion.Slerp(
            transform.rotation,
            targetRotation,
            10f * Time.deltaTime);

        animator.SetFloat("Speed", 1f);

        characterController.Move(
            direction * monsterData.moveSpeed * Time.deltaTime);
    }

    // private void PrepareComponents()
    // {
    //     characterController = GetComponent<CharacterController>();

    //     if (characterController == null)
    //     {
    //         characterController = gameObject.AddComponent<CharacterController>();
    //     }

    //     animator = GetComponent<Animator>();
    // }

    private void PrepareComponents()
    {
        characterController = GetComponent<CharacterController>();

        if (characterController != null)
            return;

        characterController = gameObject.AddComponent<CharacterController>();

        characterController.height = 1f;
        characterController.radius = 0.5f;
        characterController.center = new Vector3(0f, 0.5f, 0f);

        animator = GetComponent<Animator>();
    }
}