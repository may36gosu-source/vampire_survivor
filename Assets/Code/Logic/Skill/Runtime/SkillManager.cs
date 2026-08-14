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
        if (defaultSkill == null)
        {
            Debug.LogWarning( "SkillManager: Chưa có SkillData.");

            return false;
        }

        if (cooldownTimer > 0f)
            return false;

        if (IsCasting)
            return false;

        serialCounter++;

        // currentSkill = new SkillInstance(defaultSkill, serialCounter, transform, target);

        // // FaceTarget(target); // Quay mặt player đối diện target

        // timeline.Reset();

        // animator.SetFloat(GameConst.ANIM_SPEED, 1f);

        // animator.SetTrigger(GameConst.ANIM_ATTACK);

        // cooldownTimer = defaultSkill.Cooldown;

        // Debug.Log(
        //     $"Skill Start | " +
        //     $"ID={currentSkill.SkillId} | " +
        //     $"Serial={currentSkill.Serial} | " +
        //     $"Target={target.name}"
        // );

        currentSkill =
            new SkillInstance(
                defaultSkill,
                serialCounter,
                transform,
                target
            );

        timeline.Reset();

        GameEvents.SkillFaceTarget(target);

        cooldownTimer =
            defaultSkill.Cooldown;

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
        if (GUI.Button(new Rect(20, 20, 160, 50), "TEST SKILL"))
        {
            Transform target = FindNearestMonster();

            if (target == null)
            {
                Debug.Log( "SkillManager: Không tìm thấy Monster.");

                return;
            }

            UseSkill(target);
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

            float distanceSqr = (monster.transform.position - transform.position).sqrMagnitude;

            if (distanceSqr >= nearestDistanceSqr)
                continue;

            nearestDistanceSqr = distanceSqr;
            nearest = monster.transform;
        }

        return nearest;
    }

    // private void UpdateSkill()
    // {
    //     if (currentSkill == null)
    //         return;

    //     currentSkill.Update(
    //         Time.deltaTime
    //     );

    //     if (timeline.TryTriggerHit(
    //         currentSkill,
    //         animator))
    //     {
    //         Debug.Log(
    //             $"Skill HIT | " +
    //             $"ID={currentSkill.SkillId} | " +
    //             $"Serial={currentSkill.Serial} | " +
    //             $"Target={currentSkill.Target.name}"
    //         );
    //     }

    //     if (timeline.IsFinished(animator))
    //     {
    //         Debug.Log(
    //             $"Skill Finish | " +
    //             $"ID={currentSkill.SkillId} | " +
    //             $"Serial={currentSkill.Serial}"
    //         );

    //         currentSkill.Finish();

    //         currentSkill = null;
    //     }
    // }

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

        if (timeline.TryTriggerHit(currentSkill,animator))
        {
            
            if (vfxController != null)
            {
                vfxController.PlaySlash();
            }
            Debug.Log( $"Skill HIT | " + $"ID={currentSkill.SkillId} | " + $"Serial={currentSkill.Serial} | " + $"Target={currentSkill.Target.name}");
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