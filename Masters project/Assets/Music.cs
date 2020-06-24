using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Music : MonoBehaviour
{
    public AudioSource source;

    public AudioClip menu, game;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (SceneManager.GetSceneByBuildIndex(0) == SceneManager.GetActiveScene())
        {
            if (source.clip != menu)
            {
                source.clip = menu;
                source.Play();
            }
        }
        else
        {
            if (source.clip != game)
            {
                source.clip = game;
                source.Play();
            }
        }
    }
}
