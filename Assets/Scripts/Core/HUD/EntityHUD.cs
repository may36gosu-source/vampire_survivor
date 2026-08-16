// using UnityEngine;

// public class EntityHUD : MonoBehaviour, IPoolable
// {

//     private Entity target;

//     public Entity Target => target;

//     private Camera mainCamera;

//     private RectTransform rectTransform;

//     [SerializeField]
//     private TMPro.TextMeshProUGUI nameText;

//     [SerializeField]
//     private Color playerNameColor = Color.yellow;

//     [SerializeField]
//     private Color entityNameColor = Color.white;

//     [SerializeField]
//     private RectTransform hpFill;

//     private float originalHPBarWidth;

//     private void Awake()
//     {
//         rectTransform = GetComponent<RectTransform>();
//         originalHPBarWidth = hpFill.sizeDelta.x;
//     }

//     public void Bind(Entity entity)
//     {
//         target = entity;

//         RefreshAll();

//         gameObject.SetActive(true);
//     }

//     private void RefreshAll()
//     {
//         RefreshName();
//         RefreshHP();
//     }

//     private void RefreshName()
//     {
//        if (target == null)
//         return;

//         nameText.text = target.DisplayName;

//         nameText.color = target is PlayerController ? playerNameColor : entityNameColor;
//     }

//     public void OnSpawn()
//     {
//         mainCamera = Camera.main;
//     }

//     public void OnDespawn()
//     {
//         target = null;
//     }

//     private void LateUpdate()
//     {
//         if (target == null)
//             return;

//         UpdatePosition();

//         // if (target == null)
//         // return;

//         // Vector2 screenPoint = RectTransformUtility.WorldToScreenPoint( mainCamera, target.HeadPoint.position);

//         // RectTransform canvasRect = (RectTransform)rectTransform.parent;

//         // Vector2 localPoint;

//         // RectTransformUtility.ScreenPointToLocalPointInRectangle(canvasRect, screenPoint, null, out localPoint);

//         // rectTransform.anchoredPosition = localPoint;
//     }

//     private void UpdatePosition()
//     {
//         Vector3 screenPos = mainCamera.WorldToScreenPoint(target.HeadPoint.position);

//         rectTransform.position = screenPos;
//     }

//     public void RefreshHP()
//     {
//         if (target == null)
//         return;

//         float ratio = (float)target.CurrentHP / target.MaxHP;

//         SetHPBar(ratio);
            
//     }

//     private void SetHPBar(float ratio)
//     {
//         Vector2 size = hpFill.sizeDelta;
//         size.x = originalHPBarWidth * ratio;
//         hpFill.sizeDelta = size;
//     }

// }

using UnityEngine;

public class EntityHUD : MonoBehaviour, IPoolable
{
    private Entity target;

    public Entity Target => target;

    private Camera mainCamera;

    private RectTransform rectTransform;

    [SerializeField]
    private TMPro.TextMeshProUGUI nameText;

    [SerializeField]
    private Color playerNameColor = Color.yellow;

    [SerializeField]
    private Color entityNameColor = Color.white;

    [SerializeField]
    private RectTransform hpFill;

    private float originalHPBarWidth;

    private void Awake()
    {
        rectTransform = GetComponent<RectTransform>();

        originalHPBarWidth = hpFill.sizeDelta.x;
    }

    public void Bind(Entity entity)
    {
        target = entity;

        RefreshAll();

        gameObject.SetActive(true);
    }

    private void RefreshAll()
    {
        RefreshName();
        RefreshHP();
    }

    private void RefreshName()
    {
        if (target == null)
            return;

        nameText.text = target.DisplayName;

        nameText.color =
            target is PlayerController
                ? playerNameColor
                : entityNameColor;
    }

    public void OnSpawn()
    {
        mainCamera = Camera.main;
    }

    public void OnDespawn()
    {
        target = null;
    }

    // HUDManager gọi hàm này
    public void UpdatePosition()
    {
        if (target == null)
            return;

        if (mainCamera == null)
            return;

        Vector3 screenPos =
            mainCamera.WorldToScreenPoint(
                target.HeadPoint.position
            );

        rectTransform.position = screenPos;
    }

    public void RefreshHP()
    {
        if (target == null)
            return;

        float ratio =
            (float)target.CurrentHP /
            target.MaxHP;

        SetHPBar(ratio);
    }

    private void SetHPBar(float ratio)
    {
        Vector2 size =
            hpFill.sizeDelta;

        size.x =
            originalHPBarWidth * ratio;

        hpFill.sizeDelta = size;
    }
}