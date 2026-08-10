// using System.Collections;
// using System.Collections.Generic;
// using UnityEngine;

// public class NotificationManager : MonoBehaviour
// {
//     public static NotificationManager Instance { get; private set; }

//     [Header("Notification")]
//     [SerializeField]
//     private GameObject notificationPrefab;

//     [SerializeField]
//     private Transform bottomRoot;

//     [SerializeField]
//     private Transform centerRoot;

//     [SerializeField]
//     private float notificationSpacing = 35f;

//     [SerializeField]
//     private float bottomSpawnArea = 60f;

//     private ObjectPool notificationPool;

//     private readonly List<NotificationText> activeNotifications = new();



//     private void Awake()
//     {
//         Instance = this;

//         notificationPool = new ObjectPool(notificationPrefab, 10, bottomRoot);
//     }

//     private void Start()
//     {
//         StartCoroutine(TestNotification());

//         ShowCenter("LEVEL UP!");
//     }

//     private void OnEnable()
//     {
//         GameEvents.OnExpCollected += HandleExpCollected;
//     }

//     private void OnDisable()
//     {
//         GameEvents.OnExpCollected -= HandleExpCollected;
//     }

//     private void HandleExpCollected(int exp)
//     {
//         ShowBottom($"+{exp} EXP");
//     }

//     private IEnumerator TestNotification()
//     {
//         ShowBottom("+10 EXP");

//         yield return new WaitForSeconds(0.5f);

//         ShowBottom("+20 EXP");

//         yield return new WaitForSeconds(0.5f);

//         ShowBottom("+30 EXP");
//         // yield return null;
//     }

   

//     public void ShowBottom(string message)
//     {
//         Show(message, bottomRoot);
//     }

//     public void ShowCenter(string message)
//     {
//         Show(message, centerRoot);
//     }

//     private void Show(string message, Transform root)
//     {
//         GameObject obj = notificationPool.Get();

//         NotificationText notification = obj.GetComponent<NotificationText>();

//         notification.transform.SetParent(root, false);

//         notification.Bind(message);

//         if (root == bottomRoot)
//         {
//             SetBottomSpawnPosition(notification);
//         }

//         activeNotifications.Add(notification);
//     }


//     private void SetBottomSpawnPosition(NotificationText notification)
//     {
//         float spawnY = 0f;

//         foreach (NotificationText active in activeNotifications)
//         {
//             if (active == null)
//                 continue;

//             if (active.transform.parent != bottomRoot)
//                 continue;

//             RectTransform rect = active.GetComponent<RectTransform>();

//             float y = rect.anchoredPosition.y;

//             // Chỉ quan tâm notification còn gần đáy
//             if (y <= bottomSpawnArea)
//             {
//                 spawnY = Mathf.Max( spawnY, y + notificationSpacing );
//             }
//         }

//         RectTransform newRect = notification.GetComponent<RectTransform>();

//         newRect.anchoredPosition = new Vector2(0f, spawnY);
//     }



//     public void Release(NotificationText notification)
//     {
//         if (notification == null)
//             return;

//         activeNotifications.Remove(notification);

//         notificationPool.Release(notification.gameObject);

//     }

//     private void Update()
//     {
//         for (int i = activeNotifications.Count - 1; i >= 0; i--)
//         {
//             NotificationText notification = activeNotifications[i];

//             notification.Tick(Time.deltaTime);

//             if (notification.IsExpired)
//             {
//                 Release(notification);
//             }
//         }
//     }
// }

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NotificationManager : MonoBehaviour
{
    public static NotificationManager Instance { get; private set; }

    [Header("Notification")]
    [SerializeField]
    private GameObject notificationPrefab;

    [SerializeField]
    private Transform bottomRoot;

    [SerializeField]
    private Transform centerRoot;

    [Header("Bottom Flow")]
    [SerializeField]
    private RectTransform startPoint;

    [SerializeField]
    private RectTransform[] targetPoints;

    [SerializeField]
    private float showInterval = 0.3f;

    private ObjectPool notificationPool;

    // Tương đương UsedList
    private readonly List<NotificationText> activeNotifications = new();

    // Tương đương MsgQueue
    private readonly Queue<string> messageQueue = new();

    private float lastShowTime;

    private void Awake()
    {
        Instance = this;

        notificationPool = new ObjectPool(notificationPrefab, 10, bottomRoot);

        FindTargetPoints();
    }

    private void FindTargetPoints()
    {
        List<RectTransform> points = new();

        foreach (Transform child in bottomRoot)
        {
            if (!child.name.StartsWith("TargetPoint_"))
                continue;

            RectTransform rect = child.GetComponent<RectTransform>();

            if (rect != null)
            {
                points.Add(rect);
            }
        }

        points.Sort(
            (a, b) =>
            {
                int indexA = GetTargetIndex(a.name);
                int indexB = GetTargetIndex(b.name);

                return indexA.CompareTo(indexB);
            }
        );

        targetPoints = points.ToArray();

        Debug.Log( $"[Notification] Found Target Points = {targetPoints.Length}");
    }

    private int GetTargetIndex(string objectName)
    {
        string indexText = objectName.Replace("TargetPoint_", "");

        if (int.TryParse(indexText, out int index))
            return index;

        return int.MaxValue;
    }

    private void OnEnable()
    {
        GameEvents.OnExpCollected += HandleExpCollected;

        GameEvents.OnLevelUp += HandleLevelUp; // đăng ký sự kiện nhận level up
    }

    private void OnDisable()
    {
        GameEvents.OnExpCollected -= HandleExpCollected;

        GameEvents.OnLevelUp += HandleLevelUp; // đăng ký sự kiện nhận level up
    }

    private void Start()
    {
        ShowCenter("LEVEL UP!");
        StartCoroutine(TestNotification());
    }

    private void HandleExpCollected(int exp)
    {
        ShowBottom($"+{exp} EXP");
    }

    private void HandleLevelUp(int level)
    {
        ShowCenter($"LEVEL UP! +{level}");
    }

    private void Update()
    {
        UpdateNotifications();

        TryShowNext();
    }

    public void ShowBottom(string message)
    {
        if (string.IsNullOrEmpty(message))
            return;

        messageQueue.Enqueue(message);

        TryShowNext();
    }

    private void TryShowNext()
    {
        if (messageQueue.Count == 0)
            return;

        if (Time.time - lastShowTime < showInterval)
            return;

        if (activeNotifications.Count >= targetPoints.Length)
        {
            return;
        }

        NotificationText notification = GetNotification();

        if (notification == null)
        {
            return;
        }

        string message =  messageQueue.Dequeue();

        lastShowTime = Time.time;
        
        ShowNotification(notification, message);
    }


    private NotificationText GetNotification()
    {
        GameObject obj = notificationPool.Get();

        NotificationText notification = obj.GetComponent<NotificationText>();

        return notification;
    }

    private void ShowNotification(NotificationText notification, string message)
    {
       
        notification.transform.SetParent( bottomRoot, false);

        notification.Bind(message, startPoint.anchoredPosition);

        activeNotifications.Insert(0, notification);

        RefreshPositions();
        
    }

    private void RefreshPositions()
    {
        for (int i = 0; i < activeNotifications.Count; i++)
        {
            if (i >= targetPoints.Length)
                break;

            NotificationText notification = activeNotifications[i];

            notification.MoveTo(targetPoints[i].anchoredPosition);
        }
    }

    private void UpdateNotifications()
    {
        for (int i = activeNotifications.Count - 1; i >= 0; i--)
        {
            NotificationText notification = activeNotifications[i];

            notification.Tick(Time.deltaTime);

            if (notification.IsExpired)
            {
                Release(notification);
            }
        }
    }


    private void Release(NotificationText notification)
    {
        if (notification == null)
            return;

        activeNotifications.Remove( notification);

        notificationPool.Release( notification.gameObject);

        // Các notification còn lại
        // được refresh về lane hiện tại.
        RefreshPositions();
    }

    public void ShowCenter(string message)
    {
        GameObject obj = notificationPool.Get();

        NotificationText notification = obj.GetComponent<NotificationText>();

        notification.transform.SetParent(centerRoot, false);

        notification.Bind(  message, Vector2.zero);

        notification.MoveTo( Vector2.zero);

        StartCoroutine(ReleaseCenterNotification(notification, 3f));
    }

    private IEnumerator ReleaseCenterNotification(NotificationText notification, float duration)
    {
        yield return new WaitForSeconds(duration);

        if (notification == null)
            yield break;

        notificationPool.Release( notification.gameObject);
    }

    private IEnumerator TestNotification()
    {
        ShowBottom("+10 EXP");

        yield return new WaitForSeconds(0.1f);

        ShowBottom("+20 EXP");

        yield return new WaitForSeconds(0.1f);

        ShowBottom("+30 EXP");

        yield return new WaitForSeconds(0.1f);

        ShowBottom("+40 EXP");

        yield return new WaitForSeconds(0.1f);

        ShowBottom("+50 EXP");
    }

}