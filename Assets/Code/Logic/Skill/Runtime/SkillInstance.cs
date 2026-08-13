using UnityEngine;

public class SkillInstance
{
    public SkillData Definition { get; }

    public int SkillId =>
        Definition.SkillId;

    public int Serial { get; }

    public Transform Owner { get; }

    public Transform Target { get; }

    public float ElapsedTime { get; private set; }

    public SkillState State { get; private set; }

    public bool IsFinished =>
        State == SkillState.Finished;

    public SkillInstance(
        SkillData definition,
        int serial,
        Transform owner,
        Transform target)
    {
        Definition = definition;

        Serial = serial;

        Owner = owner;

        Target = target;

        ElapsedTime = 0f;

        State = SkillState.Running;
    }

    public void Update(float deltaTime)
    {
        if (IsFinished)
            return;

        ElapsedTime += deltaTime;

        if (ElapsedTime >= Definition.Duration)
        {
            Finish();
        }
    }

    private void Finish()
    {
        State = SkillState.Finished;
    }
}