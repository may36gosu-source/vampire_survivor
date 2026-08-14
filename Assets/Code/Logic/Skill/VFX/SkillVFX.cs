using UnityEngine;

public class SkillVFX : MonoBehaviour
{
    [SerializeField]
    private ParticleSystem[] particleSystems;

    public void Play()
    {
        Debug.Log(
            $"SkillVFX.Play() | Count={particleSystems.Length}"
        );

        foreach (ParticleSystem particle in particleSystems)
        {
            if (particle == null)
            {
                Debug.LogWarning("SkillVFX: Particle is NULL.");
                continue;
            }

            Debug.Log(
                $"Playing Particle: {particle.name}"
            );

            particle.Clear(true);
            particle.Play(true);
        }
    }

    public void Stop()
    {
        foreach (ParticleSystem particle in particleSystems)
        {
            if (particle == null)
                continue;

            particle.Stop(
                true,
                ParticleSystemStopBehavior.StopEmittingAndClear
            );
        }
    }
}