using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudibleZone : MonoBehaviour
{
    public AudioSource sound;
    public Transform player;

    // Start is called before the first frame update
    void Start()
    {
        player = CharacterController.theGoblin.transform;
        sound = transform.parent.GetComponent<AudioSource>();
        sound.Pause();
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.transform == player)
        {
            sound.UnPause();
        }
    }

    void OnTriggerExit2D(Collider2D other)
    {
        if (other.transform == player)
        {
            sound.Pause();
        }
    }
}
