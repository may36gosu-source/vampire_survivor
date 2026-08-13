using UnityEngine;

[System.Serializable]
public class DecorationConfig
{
    [SerializeField]
    private GameObject prefab;

    [SerializeField, Min(0f)]
    private float weight = 1f;

    [SerializeField, Min(0)]
    private int preloadCount = 10;

    public GameObject Prefab => prefab;
    public float Weight => weight;
    public int PreloadCount => preloadCount;
}