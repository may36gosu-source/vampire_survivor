using UnityEngine;

[CreateAssetMenu(
    fileName = "Skill_",
    menuName = "Game/Data/Skill Data"
)]
public class SkillData : ScriptableObject
{
    [Header("Identity")]
    [SerializeField]
    private int skillId;

    [Header("Cooldown")]
    [SerializeField]
    private float cooldown = 1f;

    [Header("Timeline")]
    [SerializeField, Range(0f, 1f)]
    private float hitNormalizedTime = 0.35f;

    [Header("Hit")]
    [SerializeField]
    private SkillHitDefinition hit;

    public int SkillId => skillId;

    public float Cooldown => cooldown;

    public float HitNormalizedTime => hitNormalizedTime;

    public SkillHitDefinition Hit => hit;
}