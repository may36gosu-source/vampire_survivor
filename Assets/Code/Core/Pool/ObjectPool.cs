using System.Collections.Generic;
using UnityEngine;

public class ObjectPool
{
    private readonly GameObject prefab;

    private readonly Transform parent;

    private readonly Queue<GameObject> pool = new();


    public ObjectPool(GameObject prefab, int preloadCount, Transform parent = null)
    {
        this.prefab = prefab;
        this.parent = parent;

        Preload(preloadCount);
    }


    /// <summary>
    /// Tạo sẵn Object đưa vào Pool.
    /// </summary>
    private void Preload(int count)
    {
        for (int i = 0; i < count; i++)
        {
            GameObject obj = Create();

            obj.SetActive(false);

            pool.Enqueue(obj);
        }
    }


    /// <summary>
    /// Tạo mới Object.
    /// Chỉ gọi khi Pool không còn Object.
    /// </summary>
    private GameObject Create()
    {
        GameObject obj = Object.Instantiate(prefab, parent);

        return obj;
    }


    /// <summary>
    /// Lấy Object từ Pool.
    /// </summary>
    public GameObject Get()
    {
        GameObject obj;

        if (pool.Count > 0)
        {
            obj = pool.Dequeue();
        }
        else
        {
            obj = Create();
        }

        obj.SetActive(true);

        return obj;
    }


    /// <summary>
    /// Trả Object về Pool.
    /// </summary>
    public void Release(GameObject obj)
    {
        obj.SetActive(false);

        pool.Enqueue(obj);
    }
}