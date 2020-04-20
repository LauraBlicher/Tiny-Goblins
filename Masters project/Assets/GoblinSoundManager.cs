using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoblinSoundManager : MonoBehaviour
{
    public new AudioSource audio;
    public List<AudioClip> clips = new List<AudioClip>();

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void StepEvent()
    { 
        audio.pitch = Random.Range(0.9f, 1.1f);
        int rand = Random.Range(0, clips.Count);
        audio.PlayOneShot(clips[rand]);
    }
}
