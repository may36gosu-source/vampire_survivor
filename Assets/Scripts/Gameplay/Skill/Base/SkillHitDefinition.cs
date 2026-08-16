using UnityEngine;

[System.Serializable]
public class SkillHitDefinition
{
    [SerializeField]
    private SkillHitMode mode = SkillHitMode.Single;

    [Header("AOE")]
    [SerializeField]
    private float radius = 2f;

    public SkillHitMode Mode => mode;

    public float Radius => radius;
}