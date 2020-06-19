using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class SoundManager : MonoBehaviour
{
    public AudioMixer mixer;
    [Range(-80,20)]
    public float masterVolume = 0, ambienceVolume = 0, sfxVolume = 0, musicVolume = 0;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        mixer.SetFloat("masterVolume", masterVolume);
        mixer.SetFloat("sfxVolume", sfxVolume);
        mixer.SetFloat("ambienceVolume", ambienceVolume);
        mixer.SetFloat("musicVolume", musicVolume);
    }
}
