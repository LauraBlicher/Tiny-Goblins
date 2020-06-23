using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FrogSounds : MonoBehaviour
{
    public bool active = true;
    public Animator anim;
    public AudioSource source;
    public AudioClip jump, land;
    public List<AudioClip> croaks = new List<AudioClip>();

    public float minDelay, maxDelay;

    private bool isCroaking;
    private float delay = 5f;
    public float t = 0;

    public void Croak()
    {
        isCroaking = true;
        
        source.PlayOneShot(croaks[Random.Range(0, croaks.Count)]);
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
                    anim.SetFloat("CroakBlend", 0);
                    delay = Random.Range(minDelay, maxDelay);
                    t = 0;
                }
                else
                {
                    anim.SetFloat("CroakBlend", t - delay);
                    t += Time.deltaTime * 2;
                }
            }
            else
            {
                if (t >= delay)
                    Croak();

                t += Time.deltaTime;
            }
        }
    }
}
