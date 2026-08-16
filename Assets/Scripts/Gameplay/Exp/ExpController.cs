using UnityEngine;

public class ExpController : MonoBehaviour, IPoolable
{
    [SerializeField]
    private int expValue = 10;

    [SerializeField]
    private float lifeTime = 10f;

    [SerializeField]
    private float collectRange = 2f;

    [SerializeField]
    private float collectSpeed = 12f;

    [SerializeField]
    private float collectDistance = 0.2f;

    private Rigidbody rb;

    private ObjectPool pool;
    private Transform player;

    private bool collecting;
    private float timer;

    public int ExpValue => expValue;

    private SphereCollider sphereCollider;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();

        sphereCollider = GetComponent<SphereCollider>();
    }

    public void Initialize(int value)
    {
        expValue = value;
    }

    public void SetPool(ObjectPool objectPool)
    {
        pool = objectPool;
    }

    //==================================================
    // Pool
    //==================================================

    // public void OnSpawn()
    // {
    //     collecting = false;
    //     timer = 0f;

    //     player = LocalPlayer.Transform;

    //     // Orb không dùng physics để rơi.
    //     rb.isKinematic = true;
    //     rb.useGravity = false;

    //     rb.linearVelocity = Vector3.zero;

    //     rb.angularVelocity = Vector3.zero;

    //     transform.rotation = Quaternion.identity;
    // }

    public void OnSpawn()
    {
        collecting = false;
        timer = 0f;

        player = LocalPlayer.Transform;

        // Orb không dùng physics để di chuyển.
        rb.isKinematic = true;
        rb.useGravity = false;

        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;

        // Orb mới spawn phải có Collider.
        if (sphereCollider != null)
        {
            sphereCollider.enabled = true;
        }

        transform.rotation = Quaternion.identity;
    }

    // public void OnDespawn()
    // {
    //     collecting = false;
    //     player = null;

    //     rb.linearVelocity =  Vector3.zero;

    //     rb.angularVelocity =  Vector3.zero;

    //     rb.isKinematic = true;
    //     rb.useGravity = false;
    // }

    public void OnDespawn()
    {
        collecting = false;
        player = null;

        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;

        // Giữ trạng thái mặc định của Orb.
        rb.isKinematic = true;
        rb.useGravity = false;

        // Quan trọng với Pool:
        // Nếu lần trước Orb đang collecting và đã tắt Collider,
        // lần sau lấy từ Pool phải được reset lại ở OnSpawn().
        if (sphereCollider != null)
        {
            sphereCollider.enabled = true;
        }
    }

    //==================================================
    // Update
    //==================================================

    private void Update()
    {
        if (player == null)
            return;

        timer += Time.deltaTime;

        if (timer >= lifeTime)
        {
            pool.Release(gameObject);

            return;
        }

        float distance = Vector3.Distance(transform.position, player.position);

        //==================================================
        // Detect collect
        //==================================================

        // if (!collecting)
        // {
        //     if (distance <= collectRange)
        //     {
        //         collecting = true;

        //         // Rigidbody không còn điều khiển Orb.
        //         rb.isKinematic = true;
        //     }

        //     return;
        // }

        if (!collecting)
        {
            if (distance <= collectRange)
            {
                collecting = true;

                rb.isKinematic = true;

                if (sphereCollider != null)
                {
                    sphereCollider.enabled = false;
                }
            }

            return;
        }

        //==================================================
        // Move to Player
        //==================================================

        transform.position = Vector3.MoveTowards(transform.position, player.position, collectSpeed * Time.deltaTime);

        if (Vector3.Distance(transform.position, player.position) <= collectDistance)
        {
            GameEvents.ExpCollected( expValue);

            pool.Release( gameObject);
        }
    }
}