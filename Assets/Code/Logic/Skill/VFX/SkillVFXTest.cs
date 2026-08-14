using UnityEngine;

public class SkillVFXTest : MonoBehaviour
{
    [SerializeField]
    private SkillVFX vfx;

    private void Update()
    {
        if (!Input.GetKeyDown(KeyCode.Space))
            return;

        Debug.Log(
            $"SPACE PRESSED | Tester={name}"
        );

        if (vfx == null)
        {
            Debug.LogError(
                $"SkillVFXTest: VFX is NULL | " +
                $"Tester={name}"
            );

            return;
        }

        Debug.Log("CALL VFX PLAY");

        vfx.Play();
    }

    
}