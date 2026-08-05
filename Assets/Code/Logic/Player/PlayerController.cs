using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private FixedJoystick joystick;
    [SerializeField] private float moveSpeed = 5f;

    private CharacterController controller;
    private Animator animator;

    private void Awake()
    {
        controller = GetComponent<CharacterController>();
        animator = GetComponent<Animator>();
    }

    private void Update()
    {

        Vector3 move = new Vector3(joystick.Horizontal, 0, joystick.Vertical);

        Debug.Log(move.magnitude);

        if (move.sqrMagnitude > 1f)
        {
            move.Normalize();
        }

        controller.Move(move * moveSpeed * Time.deltaTime);
        animator.SetFloat("Speed", move.magnitude);
    }
}