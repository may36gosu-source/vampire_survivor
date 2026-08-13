using UnityEngine;

public class GroundSystem : MonoBehaviour
{
    public static GroundSystem Instance { get; private set; }

    [Header("Ground")]
    [SerializeField] private LayerMask groundLayer;
    [SerializeField] private float rayHeight = 10f;
    [SerializeField] private float rayDistance = 30f;
    [SerializeField] private Transform testTarget;

    private void Awake()
    {
        Instance = this;
    }

    // private void Update()
    // {
    //     if (testTarget == null)
    //         return;

    //     Vector3 position = testTarget.position;
    //     Vector3 origin = position + Vector3.up * rayHeight;

    //     Debug.DrawLine(
    //         position,
    //         origin,
    //         Color.yellow
    //     );

    //     Debug.DrawRay(
    //         origin,
    //         Vector3.down * rayDistance,
    //         Color.green
    //     );
    // }

    public bool RaycastGround(Vector3 position, out RaycastHit hit)
    {
        Vector3 origin = position + Vector3.up * rayHeight;

        return Physics.Raycast(
            origin,
            Vector3.down,
            out hit,
            rayDistance,
            groundLayer,
            QueryTriggerInteraction.Ignore
        );
    }

    public float GetGroundY(Vector3 position)
    {
        if (RaycastGround(position, out RaycastHit hit))
            return hit.point.y;

        return position.y;
    }
}