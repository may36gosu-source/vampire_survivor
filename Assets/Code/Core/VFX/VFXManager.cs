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

        slashPool = new ObjectPool(
            slashVFXPrefab.gameObject,
            slashPreloadCount,
            skillVFXRoot
        );
    }

    public SkillVFX GetSlash()
    {
        if (slashPool == null)
            return null;

        GameObject obj = slashPool.Get();

        if (obj == null)
            return null;

        return obj.GetComponent<SkillVFX>();
    }

    public void ReleaseSlash(SkillVFX vfx)
    {
        if (slashPool == null)
            return;

        if (vfx == null)
            return;

        slashPool.Release(vfx.gameObject);
    }
}