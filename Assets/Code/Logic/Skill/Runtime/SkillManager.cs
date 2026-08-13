using UnityEngine;

public class SkillManager : MonoBehaviour
{
    [Header("Test Skill")]
    [SerializeField]
    private SkillData defaultSkill;

    private SkillInstance currentSkill;

    private SkillTimeline timeline;

    private int serialCounter;

    private float cooldownTimer;

    public bool IsCasting =>
        currentSkill != null &&
        !currentSkill.IsFinished;

    public float CooldownRemaining =>
        Mathf.Max(0f, cooldownTimer);

    private void Awake()
    {
        timeline = new SkillTimeline();
    }

    private void Update()
    {
        UpdateCooldown();

        UpdateSkill();
    }

    public bool UseSkill(Transform target)
    {
        if (defaultSkill == null)
        {
            Debug.LogWarning(
                "SkillManager: Chưa có SkillData."
            );

            return false;
        }

        if (cooldownTimer > 0f)
            return false;

        if (IsCasting)
            return false;

        serialCounter++;

        currentSkill = new SkillInstance(
            defaultSkill,
            serialCounter,
            transform,
            target
        );

        timeline.Reset();

        cooldownTimer =
            defaultSkill.Cooldown;

        Debug.Log(
            $"Skill Start | " +
            $"ID={currentSkill.SkillId} | " +
            $"Serial={currentSkill.Serial}"
        );

        return true;
    }

    private void UpdateCooldown()
    {
        if (cooldownTimer <= 0f)
            return;

        cooldownTimer -= Time.deltaTime;

        if (cooldownTimer < 0f)
            cooldownTimer = 0f;
    }

    private void OnGUI()
    {
        if (GUI.Button(
            new Rect(20, 20, 160, 50),
            "TEST SKILL"))
        {
            UseSkill(null);
        }
    }

    private void UpdateSkill()
    {
        if (currentSkill == null)
            return;

        currentSkill.Update(
            Time.deltaTime
        );

        if (timeline.TryTriggerHit(
            currentSkill))
        {
            Debug.Log(
                $"Skill HIT | " +
                $"ID={currentSkill.SkillId} | " +
                $"Serial={currentSkill.Serial}"
            );
        }

        if (currentSkill.IsFinished)
        {
            Debug.Log(
                $"Skill Finish | " +
                $"ID={currentSkill.SkillId} | " +
                $"Serial={currentSkill.Serial}"
            );

            currentSkill = null;
        }
    }
}