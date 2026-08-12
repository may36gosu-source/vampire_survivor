using TMPro;
using UnityEngine;

public class NotificationText : MonoBehaviour, IPoolable
{
    [SerializeField]
    private TextMeshProUGUI messageText;

    [Header("Move")]
    [SerializeField]
    private float moveSpeed = 50;

    [Header("Life")]
    [SerializeField]
    private float lifeTime = 2f;

    [SerializeField]
    private float fadeDuration = 0.3f;

    private CanvasGroup canvasGroup;
    private RectTransform rectTransform;

    private Vector2 moveTargetPosition;
    private Vector2 moveDirection;

    private float lifeTimer;

    private bool isMoving;
    private bool isExpired;

    public bool IsExpired => isExpired;

    public RectTransform RectTransform => rectTransform;

    private void Awake()
    {
        rectTransform = GetComponent<RectTransform>();
        canvasGroup = GetComponent<CanvasGroup>();
    }

    public void Bind(string message, Vector2 startPosition)
    {
        messageText.text = message;

        rectTransform.anchoredPosition = startPosition;

        canvasGroup.alpha = 1f;

        lifeTimer = 0f;

        isMoving = false;
        isExpired = false;

        gameObject.SetActive(true);

        
    }

    public void MoveTo(Vector2 targetPosition)
    {
        moveTargetPosition = targetPosition;

        Vector2 direction = moveTargetPosition - rectTransform.anchoredPosition;

        if (direction.sqrMagnitude <= 0.001f)
        {
            rectTransform.anchoredPosition = moveTargetPosition;

            isMoving = false;

            return;
        }

        moveDirection = direction.normalized;

        isMoving = true;
    }

    public void Tick(float deltaTime)
    {
        if (isExpired)
            return;

        UpdateMovement(deltaTime);

        UpdateLife(deltaTime);
    }

    private void UpdateMovement(float deltaTime)
    {
        if (!isMoving)
            return;

        Vector2 currentPosition = rectTransform.anchoredPosition;

        Vector2 nextPosition = currentPosition + moveDirection * moveSpeed * deltaTime;

        Vector2 remaining = moveTargetPosition - nextPosition;

        if (Vector2.Dot(remaining, moveDirection) <= 0f)
        {
            rectTransform.anchoredPosition = moveTargetPosition;

            isMoving = false;
        }
        else
        {
            rectTransform.anchoredPosition = nextPosition;
        }
    }

    private void UpdateLife(float deltaTime)
    {
        lifeTimer += deltaTime;

        if (lifeTimer >= lifeTime)
        {
            isExpired = true;
            return;
        }

        if (lifeTimer >= lifeTime - fadeDuration)
        {
            float fadeProgress = (lifeTimer - (lifeTime - fadeDuration)) / fadeDuration;

            canvasGroup.alpha = Mathf.Clamp01(1f - fadeProgress);
        }
    }

    public void OnSpawn()
    {
        canvasGroup.alpha = 1f;

        lifeTimer = 0f;

        isMoving = false;
        isExpired = false;
    }

    public void OnDespawn()
    {
        messageText.text = string.Empty;

        canvasGroup.alpha = 1f;

        rectTransform.anchoredPosition = Vector2.zero;

        moveTargetPosition = Vector2.zero;
        moveDirection = Vector2.zero;

        lifeTimer = 0f;

        isMoving = false;
        isExpired = false;
    }
}