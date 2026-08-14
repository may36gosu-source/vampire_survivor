using UnityEngine;

public class SkillTimeline
{
    private bool hitTriggered;

    public bool TryTriggerHit(SkillInstance instance, Animator animator)
    {
        if (hitTriggered)
            return false;

        if (animator == null)
            return false;

        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

        if (!state.IsTag(GameConst.ANIM_TAG_ATTACK))
            return false;

        if (state.normalizedTime < instance.Definition.HitNormalizedTime)
            return false;

        hitTriggered = true;

        return true;
    }

    public bool IsFinished( Animator animator)
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
        hitTriggered = false;
    }
}