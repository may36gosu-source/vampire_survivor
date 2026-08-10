using System.Collections;
using TMPro;
using UnityEngine;

public class DamageText : MonoBehaviour, IPoolable
{
    private DamageManager manager;

    private Camera mainCamera;
    private RectTransform rectTransform;

    private Vector3 currentPosition;
    private Vector3 velocity;

    [SerializeField]
    private TextMeshProUGUI damageText;

    [SerializeField]
    private float lifeTime = 0.8f;

    [SerializeField]
    private float fadeStartTime = 0.4f;

    private Coroutine playRoutine;

    private void Awake()
    {
        rectTransform = GetComponent<RectTransform>();
    }

    public void Bind( DamageManager manager, Vector3 position, Vector3 velocity, int damage)
    {
        this.manager = manager;

        currentPosition = position;
        this.velocity = velocity;

        damageText.text = damage.ToString();

        Color color = damageText.color;
        color.a = 1f;
        damageText.color = color;

        UpdatePosition();

        if (playRoutine != null)
        {
            StopCoroutine(playRoutine);
        }

        playRoutine = StartCoroutine(PlayRoutine());
    }

    public void OnSpawn()
    {
        mainCamera = Camera.main;
    }

    public void OnDespawn()
    {
        if (playRoutine != null)
        {
            StopCoroutine(playRoutine);
            playRoutine = null;
        }

        manager = null;

        damageText.text = string.Empty;
    }

    private IEnumerator PlayRoutine()
    {
        float timer = 0f;

        Color color = damageText.color;

        while (timer < lifeTime)
        {
            timer += Time.deltaTime;

            // Bay lên + tỏa ra
            currentPosition += velocity * Time.deltaTime;

            // Giảm vận tốc dần
            velocity = Vector3.Lerp(velocity, Vector3.zero, 5f * Time.deltaTime);

            // Fade
            if (timer >= fadeStartTime)
            {
                float fadeT = Mathf.InverseLerp(fadeStartTime, lifeTime, timer);

                color.a = 1f - fadeT;

                damageText.color = color;
            }

            UpdatePosition();

            yield return null;
        }

        playRoutine = null;

        manager.ReleaseDamage(this);
    }

    private void UpdatePosition()
    {
        if (mainCamera == null)
            return;

        Vector3 screenPosition = mainCamera.WorldToScreenPoint(currentPosition);

        rectTransform.position = screenPosition;
    }
}