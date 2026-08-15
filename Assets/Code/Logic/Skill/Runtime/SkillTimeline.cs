// using UnityEngine;

// public class SkillTimeline
// {
//     private bool hitTriggered;

//     public bool TryTriggerHit(SkillInstance instance, Animator animator)
//     {
//         if (hitTriggered)
//             return false;

//         if (animator == null)
//             return false;

//         AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

//         if (!state.IsTag(GameConst.ANIM_TAG_ATTACK))
//             return false;

//         if (state.normalizedTime < instance.Definition.HitNormalizedTime)
//             return false;

//         hitTriggered = true;

//         return true;
//     }

//     public bool IsFinished( Animator animator)
//     {
//         if (animator == null)
//             return false;

//         AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

//         if (!state.IsTag(GameConst.ANIM_TAG_ATTACK))
//             return false;

//         return state.normalizedTime >= 1f;
//     }

//     public void Reset()
//     {
//         hitTriggered = false;
//     }
// }

using UnityEngine;

public class SkillTimeline
{
    private bool vfxTriggered;
    private bool hitTriggered;


    public bool TryTriggerVFX(SkillInstance instance, Animator animator)
    {
        if (vfxTriggered)
            return false;

        if (instance == null)
            return false;

        if (animator == null)
            return false;

        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

        if (!state.IsTag(GameConst.ANIM_TAG_ATTACK))
            return false;

        if (state.normalizedTime < instance.Definition.VFXNormalizedTime)
        {
            return false;
        }

        vfxTriggered = true;

        return true;
    }


    public bool TryTriggerHit(SkillInstance instance, Animator animator)
    {
        if (hitTriggered)
            return false;

        if (instance == null)
            return false;

        if (animator == null)
            return false;

        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

        if (!state.IsTag(GameConst.ANIM_TAG_ATTACK))
            return false;

        if (state.normalizedTime < instance.Definition.HitNormalizedTime)
        {
            return false;
        }

        hitTriggered = true;

        return true;
    }


    public bool IsFinished(Animator animator)
    {
        if (animator == null)
            return false;

        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

        if (!state.IsTag(GameConst.ANIM_TAG_ATTACK))
            return false;

        return state.normalizedTime >= 1f;
    }


    public void Reset()
    {
        vfxTriggered = false;
        hitTriggered = false;
    }
}