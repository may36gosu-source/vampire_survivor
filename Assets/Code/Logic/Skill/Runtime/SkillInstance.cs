using UnityEngine;

public class SkillInstance
{
    public SkillData Definition { get; }

    public int SkillId => Definition.SkillId;

    public int Serial { get; }

    public Transform Owner { get; }

    public Transform Target { get; }

    public float ElapsedTime { get; private set; }

    public SkillState State { get; private set; }

    public bool IsFinished => State == SkillState.Finished;

    public bool AttackStarted { get; private set; }

    public Vector3 TargetPosition
    {
        get
        {
            if (Target == null)
                return Owner.position;

            return Target.position;
        }
    }


    public SkillInstance(SkillData definition, int serial, Transform owner, Transform target)
    {
        Definition = definition;

        Serial = serial;

        Owner = owner;

        Target = target;

        ElapsedTime = 0f;

        State = SkillState.Running;

        AttackStarted = false;
    }

    public void MarkAttackStarted()
    {
        AttackStarted = true;
    }

    public void Update(float deltaTime)
    {
        if (IsFinished)
        return;

        ElapsedTime += deltaTime;
    }

    public void Finish()
    {
        if (IsFinished)
            return;

        State = SkillState.Finished;
    }
}