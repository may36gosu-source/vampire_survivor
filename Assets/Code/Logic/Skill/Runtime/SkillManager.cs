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

    public bool IsCasting => currentSkill != null && !currentSkill.IsFinished;

    public float CooldownRemaining => Mathf.Max(0f, cooldownTimer);

    [Header("Animation")]
    [SerializeField]
    private Animator animator;

    private PlayerController playerController;


    [Header("VFX")]
    [SerializeField]
    private SkillVFXController vfxController;

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

    public bool UseSkill(Transform target)
    {
        // ========================================
        // SKILL DATA
        // ========================================

        if (defaultSkill == null)
        {
            Debug.LogWarning(
                "SkillManager: Chưa có SkillData."
            );

            GameEvents.SkillMessage(
                "SKILL UNAVAILABLE"
            );

            return false;
        }

        // ========================================
        // TARGET
        // ========================================

        if (target == null)
        {
            GameEvents.SkillMessage(
                "NO TARGET"
            );

            return false;
        }

        // ========================================
        // COOLDOWN
        // ========================================

        if (cooldownTimer > 0f)
        {
            GameEvents.SkillMessage(
                $"SKILL COOLDOWN {cooldownTimer:F1}s"
            );

            return false;
        }

        // ========================================
        // CASTING
        // ========================================

        if (IsCasting)
        {
            GameEvents.SkillMessage(
                "SKILL IS CASTING"
            );

            return false;
        }

        serialCounter++;

        

        currentSkill = new SkillInstance( defaultSkill, serialCounter, transform, target);

        timeline.Reset();

        GameEvents.SkillFaceTarget(target);

        cooldownTimer = defaultSkill.Cooldown;

        Debug.Log(
            $"Skill Start | " +
            $"ID={currentSkill.SkillId} | " +
            $"Serial={currentSkill.Serial} | " +
            $"Target={target.name}"
        );

        return true;
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
        if (cooldownTimer <= 0f)
            return;

        cooldownTimer -= Time.deltaTime;

        if (cooldownTimer < 0f)
            cooldownTimer = 0f;
    }

    private void OnGUI()
    {
        
        if (!GameStateHelper.IsPlaying())
        {
            return;
        }

        float width = 160f;
        float height = 50f;

        float right = 20f;
        float bottom = 50f;

        

        Rect rect = new Rect(
            Screen.width - width - right,
            Screen.height - height - bottom,
            width,
            height
        );

        if (GUI.Button(rect, "TEST SKILL"))
        {
            Transform target = FindNearestMonster();

            UseSkill(target);

            // if (target == null)
            // {
            //     GameEvents.SkillMessage(
            //         "MONSTER ERROR "
            //     );
            //     return;
            // }

            
        }
    }

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

            Debug.Log($"Skill Attack Start | " + $"Serial={currentSkill.Serial}"
            );
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

            Debug.Log(
                $"Skill HIT | " +
                $"ID={currentSkill.SkillId} | " +
                $"Serial={currentSkill.Serial} | " +
                $"Target={currentSkill.Target.name} | " +
                $"Damage={playerController.CurrentAttack}"
            );
        }

        // ========================================
        // FINISH
        // ========================================

        if (timeline.IsFinished(animator))
        {
            Debug.Log($"Skill Finish | " + $"ID={currentSkill.SkillId} | " + $"Serial={currentSkill.Serial}");

            currentSkill.Finish();

            playerController.StopSkillRotation();

            currentSkill = null;
        }
    }
}