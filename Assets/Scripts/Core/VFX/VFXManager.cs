// using UnityEngine;

// public class VFXManager : MonoBehaviour
// {
//     [Header("Skill VFX")]
//     [SerializeField]
//     private Transform skillVFXRoot;

//     [Header("Pool")]
//     [SerializeField]
//     private int preloadCount = 2;

//     [Header("Test")]
//     [SerializeField]
//     private GameObject testVFXPrefab;

//     private ObjectPool testPool;

//     private void Awake()
//     {
//         if (skillVFXRoot == null)
//         {
//             Debug.LogError(
//                 "VFXManager: Skill VFX Root chưa được gán.",
//                 this
//             );

//             return;
//         }

//         if (preloadCount < 1)
//         {
//             Debug.LogError(
//                 "VFXManager: Preload Count phải >= 1.",
//                 this
//             );

//             return;
//         }

//         if (testVFXPrefab == null)
//         {
//             Debug.LogError(
//                 "VFXManager: Test VFX Prefab chưa được gán.",
//                 this
//             );

//             return;
//         }

//         testPool = new ObjectPool(
//             testVFXPrefab,
//             preloadCount,
//             skillVFXRoot
//         );
//     }

//     public GameObject GetTestVFX()
//     {
//         if (testPool == null)
//             return null;

//         GameObject obj = testPool.Get();

//         if (obj == null)
//             return null;

//         obj.transform.SetParent(
//             skillVFXRoot,
//             false
//         );

//         obj.transform.localPosition =
//             Vector3.zero;

//         obj.transform.localRotation =
//             Quaternion.identity;

//         obj.transform.localScale =
//             Vector3.one;

//         return obj;
//     }

//     public void ReleaseTestVFX(GameObject obj)
//     {
//         if (testPool == null)
//             return;

//         if (obj == null)
//             return;

//         testPool.Release(obj);
//     }


// }

using UnityEngine;

public class VFXManager : MonoBehaviour
{
    [Header("Skill VFX")]
    [SerializeField]
    private Transform skillVFXRoot;

    [Header("Slash VFX")]
    [SerializeField]
    private SkillVFX slashVFXPrefab;

    [SerializeField]
    private int slashPreloadCount = 3;

    private ObjectPool slashPool;

    private void Awake()
    {
        if (skillVFXRoot == null)
        {
            Debug.LogError(
                "VFXManager: Skill VFX Root chưa được gán.",
                this
            );

            return;
        }

        if (slashVFXPrefab == null)
        {
            Debug.LogError(
                "VFXManager: Slash VFX Prefab chưa được gán.",
                this
            );

            return;
        }

        if (slashPreloadCount < 1)
        {
            Debug.LogError(
                "VFXManager: Slash Preload Count phải >= 1.",
                this
            );

            return;
        }

        slashPool = new ObjectPool(
            slashVFXPrefab.gameObject,
            slashPreloadCount,
            skillVFXRoot
        );
    }

    private void OnEnable()
    {
        GameEvents.OnSkillVFXFinished += HandleSkillVFXFinished;
    }

    private void OnDisable()
    {
        GameEvents.OnSkillVFXFinished -= HandleSkillVFXFinished;
    }

    public SkillVFX GetSlash()
    {
        if (slashPool == null)
            return null;

        GameObject obj = slashPool.Get();

        if (obj == null)
            return null;

        SkillVFX vfx =
            obj.GetComponent<SkillVFX>();

        if (vfx == null)
        {
            Debug.LogError(
                "VFXManager: Slash VFX không có SkillVFX.",
                obj
            );

            slashPool.Release(obj);

            return null;
        }

        return vfx;
    }

    private void HandleSkillVFXFinished(SkillVFX vfx)
    {
        if (vfx == null)
            return;

        if (slashPool == null)
            return;

        slashPool.Release(vfx.gameObject);
    }
}