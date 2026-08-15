using UnityEngine;

public class SkillVFXController : MonoBehaviour
{
    [Header("VFX")]
    [SerializeField]
    private SkillVFX slashVFXPrefab;

    [Header("Slots")]
    [SerializeField]
    private Transform weaponSlot;

    public void PlaySlash()
    {
        if (slashVFXPrefab == null)
        {
            // Debug.LogWarning("SkillVFXController: Chưa gán Slash VFX.");

            return;
        }

        if (weaponSlot == null)
        {
            // Debug.LogWarning("SkillVFXController: Chưa gán Weapon Slot.");

            return;
        }

        // Debug.Log( $"VFX Spawn | " + $"Slot={weaponSlot.name} | " + $"Position={weaponSlot.position} | " +  $"Rotation={weaponSlot.rotation.eulerAngles}");

        SkillVFX vfx = Instantiate(slashVFXPrefab, weaponSlot.position, weaponSlot.rotation);

        vfx.Play();
    }
}