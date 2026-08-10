using UnityEngine;

// public class ExpController : MonoBehaviour, IPoolable
// {
//     [SerializeField]
//     private int expValue = 10;

//     private ObjectPool pool;

//     private Transform player;

//     private bool collecting;

//     public int ExpValue => expValue;

//     [SerializeField]
//     private float lifeTime = 10f;

//     private float timer;

//     public void Initialize(int value)
//     {
//         expValue = value;
//     }

//     public void SetPool(ObjectPool objectPool)
//     {
//         pool = objectPool;
//     }

//     public void OnSpawn()
//     {
//         collecting = false;

//         timer = 0f;
//         player = LocalPlayer.Transform;
//     }

//     public void OnDespawn()
//     {
//         collecting = false;
//     }

//     private void Update()
//     {
//         if (player == null)
//             return;


//         timer += Time.deltaTime;

//         if (timer >= lifeTime)
//         {
//             pool.Release(gameObject);
//             return;
//         }

//         float distance = Vector3.Distance(transform.position, player.position);

//         if (!collecting)
//         {
//             if (distance <= 2f)
//             {
//                 collecting = true;
//             }

//             return;
//         }

//         transform.position = Vector3.MoveTowards(transform.position, player.position, 12f * Time.deltaTime);

//         if (distance <= 0.2f)
//         {
//             Debug.Log($"Get Exp : {expValue}");

//             GameEvents.ExpCollected(expValue);

//             pool.Release(gameObject);
//         }
//     }
// }

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

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }

    public void Initialize(int value)
    {
        expValue = value;
    }

    public void SetPool(ObjectPool objectPool)
    {
        pool = objectPool;
    }

    public void OnSpawn()
    {
        collecting = false;
        timer = 0f;
        player = LocalPlayer.Transform;

        // Reset physics state
        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
    }

    public void OnDespawn()
    {
        collecting = false;
        player = null;

        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
    }

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

        float distance = Vector3.Distance( transform.position, player.position );

        if (!collecting)
        {
            if (distance <= collectRange)
            {
                collecting = true;
            }

            return;
        }

        transform.position = Vector3.MoveTowards( transform.position, player.position, collectSpeed * Time.deltaTime);

        if (Vector3.Distance(transform.position, player.position) <= collectDistance)
        {
            GameEvents.ExpCollected(expValue);

            pool.Release(gameObject);
        }
    }
}