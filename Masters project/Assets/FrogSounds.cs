using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FrogSounds : MonoBehaviour
{
    public bool active = true;
    public Animator anim;
    public AudioSource source;
    public AudioClip jump, land, croak;

    public float minDelay, maxDelay;

    private bool isCroaking;
    private float delay = 5f;
    private float t = 0;

    public void Croak()
    {
        isCroaking = true;
        anim.SetTrigger("croak");
        source.PlayOneShot(croak);
    }
    
    public void Jump()
    {
        source.PlayOneShot(jump);
    }

    public void Land()
    {
        source.PlayOneShot(land);
    }

    public void Update()
    {
        if (active)
        {
            if (isCroaking)
            {
                if (!source.isPlaying)
                {
                    isCroaking = false;
                    anim.SetTrigger("noCroak");
                    delay = Random.Range(minDelay, maxDelay);
                    t = 0;
                }
            }
            else
            {
                if (t >= delay)
                    Croak();
                else
                {
                    t += Time.deltaTime;
                }
            }
        }
    }
}
