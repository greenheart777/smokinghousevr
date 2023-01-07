using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControlFire : MonoBehaviour
{
    [Tooltip("All particles that must be activated at the time of burning.")]
    public ParticleSystem fireParticle;
    [Tooltip("All audio sources that must be activated at the time of burning")]
    public AudioSource audioSource;

    [Tooltip("How long the start of burning will last")]
    public float StartBurnning = 6f;
    [Tooltip("How long will the burning last")]
    public float Burning = 8f;
    [Tooltip("How long the burning will fade")]
    public float StopBurning = 20f;

    [Tooltip("Array of particles that must be activated at the time of burning.")]
    public int[] EmissionsOfParticles;
    [Tooltip("Array of audio that must be activated at the time of burning.")]
    public Light[] lights;


    ParticleSystem[] EmissionPS;
    int[] lightsRandomIntense;

    float timer = 0f;
    float count = 0f;

    bool cleanCount, activateParticle = true;

    private void Start()
    {
        // control global floats of burning
        Shader.SetGlobalFloat("StartBurning", 0);
        Shader.SetGlobalFloat("StopBurning", 0);

        // filling the array of emitters with all partical systems
        if (fireParticle != null)
        {
            EmissionPS = new ParticleSystem[fireParticle.transform.childCount];
            for (int i = 0; i < fireParticle.transform.childCount; i++)
            {
                EmissionPS[i] = fireParticle.transform.GetChild(i).GetComponent<ParticleSystem>();
            }
        }

        // filling the array of point lights with all lights systems
        if (lights != null)
        {
            lightsRandomIntense = new int[lights.Length];
            for (int i = 0; i < lights.Length; i++)
            {
                lightsRandomIntense[i] = Random.Range(1, 5);
                lights[i].intensity = 0;
            }
        }

    }

    void Update()
    {
        timer += Time.deltaTime;

        // events during the onset of burning
        if (timer < StartBurnning && timer < StartBurnning + Burning)
        {
            if (fireParticle != null)
            {
                if (activateParticle)
                {
                    activateParticle = false;
                    fireParticle.Play(true);
                }
            }

            count = timer / StartBurnning;

            if(audioSource != null)
                audioSource.volume = count;
            Shader.SetGlobalFloat("StartBurning", count);
            if (fireParticle != null)
                ChangeParticleEmission(count);
            ControlLight(1, count);
        }

        // events of burning 
        if (timer > StartBurnning && timer < StartBurnning + Burning)
        {
            count = ((timer - StartBurnning) / Burning);

            if (fireParticle != null)
                ChangeParticleEmission(1 - count);
            ControlLight(1, count);
            //audioSource.volume -= Time.deltaTime;
        }

        // events after burning
        if (timer > StartBurnning + Burning)
        {
            if (activateParticle == false)
            {
                activateParticle = true;
                fireParticle.Stop(true);
            }

            if (cleanCount)
            {
                count = 0;
                cleanCount = false;
            }

            count = (timer - (StartBurnning + Burning)) / StopBurning;

            if(audioSource != null)
                audioSource.volume -= Time.deltaTime;
            Shader.SetGlobalFloat("StopBurning", count);
            ControlLight(2, count);
        }

        // script shutdown
        if (timer > StartBurnning + Burning + StopBurning)
        {
            this.enabled = false;
        }
    }



    // control amount of particles in emitters
    void ChangeParticleEmission(float timer)
    {
        for (int i = 0; i < EmissionPS.Length -1; i++)
        {
            ParticleSystem fire = EmissionPS[i];
            var em = fire.emission;
            em.rateOverTime = Mathf.FloorToInt(timer * EmissionsOfParticles[i]);
        }
    }


    // control point lights of fire
    void ControlLight(int whatToDo, float timer)
    {
        //brightness increase
        if (whatToDo == 1)
        {
            for (int i = 0; i < lights.Length; i++)
            {
                lights[i].intensity += Time.deltaTime;
            }
        }

        // brightness reduction
        if (whatToDo == 2)
        {
            for (int i = 0; i < lights.Length; i++)
            {
                lights[i].intensity -= Time.deltaTime * 4;
            }
        }

        // flickering
        if (whatToDo == 2 && 1 - count > 0.9f || whatToDo == 1) {
            for (int i = 0; i < lights.Length; i++)
            {
                if (lights[i].intensity < 6)
                {
                    lights[i].intensity += Random.Range(-timer, timer);
                }

                if (lights[i].intensity > 6)
                {
                    lights[i].intensity += Random.Range(-timer * 2, -timer);
                }

                if (lights[i].intensity < 3)
                {
                    lights[i].intensity += Random.Range(timer, timer * 2);
                }
            }
        }
    }

}
