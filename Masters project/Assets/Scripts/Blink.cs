using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Blink : MonoBehaviour
{
    public float minDelay = 1f;
    public float t = 0f;
    public int frameCount = 4, i = 0; 

    public SpriteRenderer sr;
    public Sprite eyeOpen, eyeClosed;
    public bool blinked;

    // Start is called before the first frame update
    void Start()
    {
        sr = GetComponent<SpriteRenderer>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        sr.sprite = blinked ? eyeClosed : eyeOpen;
        if (blinked)
        {
            if(i >= frameCount)
            {
                i = 0;
                blinked = false;
            }
            else
            {
                i++;
                t = 0;
                return;
            }
        }

        if(t > minDelay)
        {
            blinked = Random.Range(0, 60) == 0;
        }
        t += Time.deltaTime;
        
    }
}
