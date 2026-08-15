using UnityEngine;

[System.Serializable]
public class SkillVFXDefinition
{
    [SerializeField]
    private SkillVFX prefab;

    [Header("Spawn")]
    [SerializeField]
    private bool attachToWeapon = true;

    [Header("Offset")]
    [SerializeField]
    private Vector3 positionOffset;

    [SerializeField]
    private Vector3 rotationOffset;

    public SkillVFX Prefab => prefab;

    public bool AttachToWeapon => attachToWeapon;

    public Vector3 PositionOffset => positionOffset;

    public Vector3 RotationOffset => rotationOffset;
}