// using UnityEngine;

// public class SkillVFX : MonoBehaviour
// {
//     [SerializeField]
//     private ParticleSystem[] particleSystems;

//     public void Play()
//     {
//         Debug.Log($"SkillVFX.Play() | Count={particleSystems.Length}");

//         foreach (ParticleSystem particle in particleSystems)
//         {
//             if (particle == null)
//             {
//                 Debug.LogWarning("SkillVFX: Particle is NULL.");
//                 continue;
//             }

//             Debug.Log( $"Playing Particle: {particle.name}");

//             particle.Clear(true);
//             particle.Play(true);
//         }
//     }

//     public void Stop()
//     {
//         foreach (ParticleSystem particle in particleSystems)
//         {
//             if (particle == null)
//                 continue;

//             particle.Stop( true,ParticleSystemStopBehavior.StopEmittingAndClear);
//         }
//     }
// }

using System.Collections;
using UnityEngine;

public class SkillVFX : MonoBehaviour, IPoolable
{
    [SerializeField]
    private ParticleSystem[] particleSystems;

    private Coroutine releaseRoutine;

    public void Play()
    {
        if (releaseRoutine != null)
        {
            StopCoroutine(releaseRoutine);
            releaseRoutine = null;
        }

        foreach (ParticleSystem particle in particleSystems)
        {
            if (particle == null)
                continue;

            particle.Stop(
                true,
                ParticleSystemStopBehavior.StopEmittingAndClear
            );

            particle.Clear(true);
            particle.Play(true);
        }

        releaseRoutine =
            StartCoroutine(WaitForComplete());
    }

    private IEnumerator WaitForComplete()
    {
        while (true)
        {
            bool alive = false;

            foreach (ParticleSystem particle in particleSystems)
            {
                if (particle == null)
                    continue;

                if (particle.IsAlive(true))
                {
                    alive = true;
                    break;
                }
            }

            if (!alive)
                break;

            yield return null;
        }

        releaseRoutine = null;

        GameEvents.SkillVFXFinished(this);
    }

    public void OnSpawn()
    {
        // Reset trạng thái nếu cần.
        //         foreach (ParticleSystem particle in particleSystems)
        //         {
        //             if (particle == null)
        //                 continue;

        //             particle.Clear(true);
        //             particle.Play(true);
        //         }
    }

    public void OnDespawn()
    {
        if (releaseRoutine != null)
        {
            StopCoroutine(releaseRoutine);
            releaseRoutine = null;
        }

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

// using UnityEngine;

// public class SkillVFX : MonoBehaviour, IPoolable
// {
//     [SerializeField]
//     private ParticleSystem[] particleSystems;

//     public void OnSpawn()
//     {
//         foreach (ParticleSystem particle in particleSystems)
//         {
//             if (particle == null)
//                 continue;

//             particle.Clear(true);
//             particle.Play(true);
//         }
//     }

//     public void OnDespawn()
//     {
//         foreach (ParticleSystem particle in particleSystems)
//         {
//             if (particle == null)
//                 continue;

//             particle.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
//         }
//     }

//     public bool IsFinished()
//     {
//         foreach (ParticleSystem particle in particleSystems)
//         {
//             if (particle == null)
//                 continue;

//             if (particle.IsAlive(true))
//                 return false;
//         }

//         return true;
//     }
// }