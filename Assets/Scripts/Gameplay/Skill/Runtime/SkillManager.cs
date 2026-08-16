using UnityEngine;
using System.Collections.Generic;
public class SkillManager : MonoBehaviour
{
    [Header("Test Skill")]
    [SerializeField]
    private SkillData defaultSkill;

    private SkillInstance currentSkill;

    private SkillTimeline timeline;

    private int serialCounter;

    private readonly Dictionary<SkillData, float> cooldownTimers = new();

    public bool IsCasting => currentSkill != null && !currentSkill.IsFinished;

    // public float CooldownRemaining => Mathf.Max(0f, cooldownTimer);

    [Header("Animation")]
    [SerializeField]
    private Animator animator;

    private PlayerController playerController;


    [Header("VFX")]
    [SerializeField]
    private SkillVFXController vfxController;


    public float GetCooldownRemaining(SkillData skill)
    {
        if (skill == null)
            return 0f;

        if (!cooldownTimers.TryGetValue(skill,  out float remaining))
        {
            return 0f;
        }

        return Mathf.Max(0f, remaining);
    }

    private void Awake()
    {
        timeline = new SkillTimeline();

        playerController = GetComponent<PlayerController>();
    }

    private void Update()
    {
        UpdateCooldown();

        UpdateSkill();
    }

    public bool UseSkill(SkillData skill,Transform target)
    {
        // ========================================
        // SKILL DATA
        // ========================================

        if (skill == null)
        {
            GameEvents.SkillMessage("SKILL UNAVAILABLE");

            return false;
        }

        // ========================================
        // PLAYER
        // ========================================

        if (playerController != null &&
            playerController.IsDead)
        {
            return false;
        }

        // ========================================
        // TARGET
        // ========================================

        if (target == null)
        {
            GameEvents.SkillMessage("NO TARGET" );

            return false;
        }

        // ========================================
        // COOLDOWN
        // ========================================

        float cooldownRemaining = GetCooldownRemaining(skill);

        if (cooldownRemaining > 0f)
        {
            GameEvents.SkillMessage($"SKILL COOLDOWN {cooldownRemaining:F1}s");

            return false;
        }

        // ========================================
        // CASTING
        // ========================================

        if (IsCasting)
        {
            GameEvents.SkillMessage("SKILL IS CASTING");
            return false;
        }

        // ========================================
        // CREATE SKILL INSTANCE
        // ========================================

        serialCounter++;

        currentSkill =  new SkillInstance( skill, serialCounter, transform, target);

        timeline.Reset();

        GameEvents.SkillFaceTarget(target);

        // ========================================
        // START COOLDOWN
        // ========================================

        cooldownTimers[skill] = skill.Cooldown;

        return true;
    }

    public bool TryUseDefaultSkill()
    {
        return TryUseSkill(defaultSkill);
    }

    public bool TryUseSkill(SkillData skill)
    {
        if (playerController != null &&
            playerController.IsDead)
        {
            return false;
        }

        Transform target =
            FindNearestMonster();

        if (target == null)
        {
            GameEvents.SkillMessage(
                "NO TARGET"
            );

            return false;
        }

        return UseSkill(
            skill,
            target
        );
    }

    private void FaceTarget(Transform target)
    {
        if (target == null)
            return;

        Vector3 direction = target.position - transform.position;

        direction.y = 0f;

        if (direction.sqrMagnitude <= 0.001f)
            return;

        transform.rotation = Quaternion.LookRotation(direction);
    }

    private void UpdateCooldown()
    {
        if (cooldownTimers.Count == 0)
            return;

        List<SkillData> skills = new(cooldownTimers.Keys);

        foreach (SkillData skill in skills)
        {
            float remaining = cooldownTimers[skill];

            remaining -= Time.deltaTime;

            if (remaining <= 0f)
            {
                cooldownTimers.Remove(skill);
            }
            else
            {
                cooldownTimers[skill] = remaining;
            }
        }
    }

    // private void OnGUI()
    // {
        
    //     if (!GameStateHelper.IsPlaying())
    //     {
    //         return;
    //     }

    //     float width = 160f;
    //     float height = 50f;

    //     float right = 20f;
    //     float bottom = 50f;

        

    //     Rect rect = new Rect(
    //         Screen.width - width - right,
    //         Screen.height - height - bottom,
    //         width,
    //         height
    //     );

    //     if (GUI.Button(rect, "TEST SKILL"))
    //     {
    //         Transform target = FindNearestMonster();

    //         TryUseSkill(defaultSkill);

    //         // if (target == null)
    //         // {
    //         //     GameEvents.SkillMessage(
    //         //         "MONSTER ERROR "
    //         //     );
    //         //     return;
    //         // }

            
    //     }
    // }

    private Transform FindNearestMonster()
    {
        Collider[] hits = Physics.OverlapSphere(transform.position, 5f);

        Transform nearest = null;

        float nearestDistanceSqr = float.MaxValue;

        foreach (Collider hit in hits)
        {
            MonsterController monster = hit.GetComponentInParent<MonsterController>();

            if (monster == null)
                continue;
            if (monster.IsDead)
                continue;

            float distanceSqr = (monster.transform.position - transform.position).sqrMagnitude;

            if (distanceSqr >= nearestDistanceSqr)
                continue;

            nearestDistanceSqr = distanceSqr;
            nearest = monster.transform;
        }

        return nearest;
    }

    

    private void UpdateSkill()
    {
        if (currentSkill == null)
            return;

        currentSkill.Update(Time.deltaTime);

        // ========================================
        // WAIT FACE TARGET
        // ========================================

        if (!currentSkill.AttackStarted)
        {
            if (!playerController.IsFacingTarget(currentSkill.Target))
            {
                return;
            }

            currentSkill.MarkAttackStarted();

            animator.SetFloat(GameConst.ANIM_SPEED, 1f);

            animator.ResetTrigger(GameConst.ANIM_ATTACK);

            animator.SetTrigger(GameConst.ANIM_ATTACK);

            // Debug.Log($"Skill Attack Start | " + $"Serial={currentSkill.Serial}");
        }

        // ========================================
        // HIT
        // ========================================

        if (timeline.TryTriggerHit(currentSkill, animator))
        {
            MonsterController target =
                currentSkill.Target.GetComponent<MonsterController>();

            if (target != null)
            {
                target.TakeDamage(playerController.CurrentAttack);
            }

            if (vfxController != null)
            {
                vfxController.PlaySlash();
            }

            // Debug.Log( $"Skill HIT | " + $"ID={currentSkill.SkillId} | " + $"Serial={currentSkill.Serial} | " + $"Target={currentSkill.Target.name} | " + $"Damage={playerController.CurrentAttack}" );
        }

        // ========================================
        // FINISH
        // ========================================

        if (timeline.IsFinished(animator))
        {
            // Debug.Log($"Skill Finish | " + $"ID={currentSkill.SkillId} | " + $"Serial={currentSkill.Serial}");

            currentSkill.Finish();

            playerController.StopSkillRotation();

            currentSkill = null;
        }
    }
}