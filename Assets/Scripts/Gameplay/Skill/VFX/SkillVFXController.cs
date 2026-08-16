using UnityEngine;

public class SkillVFXController : MonoBehaviour
{
    [Header("Manager")]
    [SerializeField]
    private VFXManager vfxManager;

    [Header("Slots")]
    [SerializeField]
    private Transform weaponSlot;

    public void PlaySlash()
    {
        if (vfxManager == null)
            return;

        if (weaponSlot == null)
            return;

        SkillVFX vfx =
            vfxManager.GetSlash();

        if (vfx == null)
            return;

        Transform vfxTransform =
            vfx.transform;

        vfxTransform.SetPositionAndRotation(
            weaponSlot.position,
            weaponSlot.rotation
        );

        vfxTransform.localScale =
            Vector3.one;

        vfx.Play();
    }
}