using System.Collections.Generic;
using UnityEngine;

public class DamageManager : MonoBehaviour
{
    [Header("Damage")]
    [SerializeField]
    private GameObject damageTextPrefab;

    [SerializeField]
    private Transform damageRoot;

    private ObjectPool damagePool;

    private readonly List<DamageText> activeDamages = new();

    private void Awake()
    {
        damagePool = new ObjectPool(damageTextPrefab, 21, damageRoot);
    }

    private void OnEnable()
    {
        GameEvents.OnPopupDamage += PopupDamage;
    }

    private void OnDisable()
    {
        GameEvents.OnPopupDamage -= PopupDamage;
    }

    

    public void PopupDamage(Vector3 hitPosition, Vector3 hitDirection, int damage)
    {   
        // Vector vuông góc với hướng đánh
        Vector3 side = Vector3.Cross(Vector3.up, hitDirection).normalized;

        // Vị trí spawn trong vùng hình quạt
        float sideOffset = Random.Range(-0.35f, 0.35f);
        float heightOffset = Random.Range(0.05f, 0.2f);

        Vector3 spawnPosition =  hitPosition + hitDirection * 0.2f  + side * sideOffset + Vector3.up * heightOffset;

        // Hướng bay
        Vector3 velocity = hitDirection * 0.25f + Vector3.up * 0.8f + side * Random.Range(-0.25f, 0.25f);

        GameObject obj = damagePool.Get();

        DamageText damageText = obj.GetComponent<DamageText>();

        damageText.Bind( this, spawnPosition, velocity, damage);

        activeDamages.Add(damageText);
    }   

    public void ReleaseDamage(DamageText damageText)
    {
        if (!activeDamages.Remove(damageText))
            return;

        damagePool.Release(damageText.gameObject);
    }


}