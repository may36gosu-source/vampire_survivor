public class SkillTimeline
{
    private bool hitTriggered;

    public bool TryTriggerHit(
        SkillInstance instance)
    {
        if (hitTriggered)
            return false;

        if (instance.ElapsedTime <
            instance.Definition.HitTime)
            return false;

        hitTriggered = true;

        return true;
    }

    public void Reset()
    {
        hitTriggered = false;
    }
}