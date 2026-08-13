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
    [SerializeField]
    private float duration = 1f;

    [SerializeField]
    private float hitTime = 0.35f;

    [Header("Hit")]
    [SerializeField]
    private SkillHitDefinition hit;

    public int SkillId => skillId;

    public float Cooldown => cooldown;

    public float Duration => duration;

    public float HitTime => hitTime;

    public SkillHitDefinition Hit => hit;
}