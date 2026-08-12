// using System.Collections.Generic;
// using UnityEngine;

// public class DamageManager : MonoBehaviour
// {
//     [Header("Damage")]
//     [SerializeField]
//     private GameObject damageTextPrefab;

//     [SerializeField]
//     private Transform damageRoot;

//     private ObjectPool damagePool;

//     private readonly List<DamageText> activeDamages = new();



//     [Header("Damage Fan")]
//     [SerializeField] private float sideRange = 0.45f;
//     [SerializeField] private float forwardRange = 0.35f;
//     [SerializeField] private float heightRange = 0.25f;

//     [Header("Damage Stack")]
//     [SerializeField] private float stackRadius = 0.35f;
//     [SerializeField] private int maxStackAttempts = 10;

//     [Header("Damage Flight")]
//     [SerializeField] private float horizontalSpeed = 0.25f;
//     [SerializeField] private float upwardSpeed = 0.8f;
//     [SerializeField] private float sideSpeed = 0.3f;


//     private void Awake()
//     {
//         damagePool = new ObjectPool(damageTextPrefab, 21, damageRoot);
//     }

//     private void OnEnable()
//     {
//         GameEvents.OnPopupDamage += PopupDamage;
//     }

//     private void OnDisable()
//     {
//         GameEvents.OnPopupDamage -= PopupDamage;
//     }

    

//     public void PopupDamage(Vector3 hitPosition, Vector3 hitDirection, int damage)
//     {   
//         // Vector vuông góc với hướng đánh
//         Vector3 side = Vector3.Cross(Vector3.up, hitDirection).normalized;

//         // Vị trí spawn trong vùng hình quạt
//         float sideOffset = Random.Range(-0.35f, 0.35f);
//         float heightOffset = Random.Range(0.05f, 0.2f);

//         Vector3 spawnPosition =  hitPosition + hitDirection * 0.2f  + side * sideOffset + Vector3.up * heightOffset;

//         // Hướng bay
//         Vector3 velocity = hitDirection * 0.25f + Vector3.up * 0.8f + side * Random.Range(-0.25f, 0.25f);

//         GameObject obj = damagePool.Get();

//         DamageText damageText = obj.GetComponent<DamageText>();

//         damageText.Bind( this, spawnPosition, velocity, damage);

//         activeDamages.Add(damageText);
//     }   

//     public void ReleaseDamage(DamageText damageText)
//     {
//         if (!activeDamages.Remove(damageText))
//             return;

//         damagePool.Release(damageText.gameObject);
//     }


// }

using System.Collections.Generic;
using UnityEngine;

public class DamageManager : MonoBehaviour
{
    [Header("Damage")]
    [SerializeField] private GameObject damageTextPrefab;
    [SerializeField] private Transform damageRoot;
    private ObjectPool damagePool;
    private readonly List<DamageText> activeDamages = new();

    [Header("Fan Spawn")]
    [SerializeField] private float sideRange = 0.45f;
    [SerializeField] private float forwardRange = 0.35f;
    [SerializeField] private float heightRange = 0.25f;

    [Header("Damage Spacing")]
    [SerializeField] private float minSpacing = 55f;
    [SerializeField] private int maxStackAttempts = 15;

    [Header("Damage Flight")]
    [SerializeField] private float horizontalSpeed = 0.25f;
    [SerializeField] private float upwardSpeed = 0.8f;
    [SerializeField] private float sideSpeed = 0.3f;

    private Camera mainCamera;

    private void Awake()
    {
        damagePool = new ObjectPool(damageTextPrefab, 21, damageRoot);
        mainCamera = Camera.main;
    }

    private void OnEnable() => GameEvents.OnPopupDamage += PopupDamage;
    private void OnDisable() => GameEvents.OnPopupDamage -= PopupDamage;

    public void PopupDamage(Vector3 hitPosition, Vector3 hitDirection, int damage)
    {
        if (mainCamera == null) mainCamera = Camera.main;
        if (mainCamera == null) return;

        hitDirection.y = 0f;
        if (hitDirection.sqrMagnitude < 0.001f) hitDirection = Vector3.forward;
        hitDirection.Normalize();

        Vector3 side = Vector3.Cross(Vector3.up, hitDirection).normalized;
        Vector3 spawnPosition = FindBestSpawnPosition(hitPosition, hitDirection, side);

        float randomSide = Random.Range(-sideSpeed, sideSpeed);
        Vector3 velocity = hitDirection * Random.Range(horizontalSpeed * 0.7f, horizontalSpeed);
        velocity += Vector3.up * Random.Range(upwardSpeed * 0.85f, upwardSpeed * 1.15f);
        velocity += side * randomSide;

        GameObject obj = damagePool.Get();
        if (obj == null) return;

        DamageText damageText = obj.GetComponent<DamageText>();
        if (damageText == null)
        {
            damagePool.Release(obj);
            return;
        }

        damageText.Bind(this, spawnPosition, velocity, damage);
        activeDamages.Add(damageText);
    }

    private Vector3 FindBestSpawnPosition(Vector3 hitPosition, Vector3 hitDirection, Vector3 side)
    {
        if (activeDamages.Count == 0) return CreateRandomSpawnPosition(hitPosition, hitDirection, side);

        Vector3 bestPosition = hitPosition;
        float bestDistance = -1f;

        for (int i = 0; i < maxStackAttempts; i++)
        {
            Vector3 candidate = CreateRandomSpawnPosition(hitPosition, hitDirection, side);
            Vector3 candidateScreen = mainCamera.WorldToScreenPoint(candidate);
            float nearestDistance = GetNearestScreenDistance(candidateScreen);

            if (nearestDistance >= minSpacing) return candidate;

            if (nearestDistance > bestDistance)
            {
                bestDistance = nearestDistance;
                bestPosition = candidate;
            }
        }

        return bestPosition;
    }

    private Vector3 CreateRandomSpawnPosition(Vector3 hitPosition, Vector3 hitDirection, Vector3 side)
    {
        float sideOffset = Random.Range(-sideRange, sideRange);
        float forwardOffset = Random.Range(0.05f, forwardRange);
        float heightOffset = Random.Range(-0.05f, heightRange);

        return hitPosition + hitDirection * forwardOffset + side * sideOffset + Vector3.up * heightOffset;
    }

    private float GetNearestScreenDistance(Vector3 screenPosition)
    {
        if (activeDamages.Count == 0) return float.MaxValue;

        float nearestDistance = float.MaxValue;

        foreach (DamageText damage in activeDamages)
        {
            if (damage == null) continue;

            Vector3 otherScreen = damage.ScreenPosition;
            float distance = Vector2.Distance(screenPosition, otherScreen);
            if (distance < nearestDistance) nearestDistance = distance;
        }

        return nearestDistance;
    }

    public void ReleaseDamage(DamageText damageText)
    {
        if (!activeDamages.Remove(damageText)) return;
        damagePool.Release(damageText.gameObject);
    }
}