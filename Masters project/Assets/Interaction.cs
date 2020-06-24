using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interaction : MonoBehaviour
{
    public static bool angrySpokenTo = false;
    public bool isAngry;
    public bool isFred;
    public bool ready = false;
    private bool speaking = false;
    public bool done = false;
    public bool faceOnInteract = false;
    public bool hasSecondLine = false;
    public bool firstLineSpoken = false;
    public bool secondLineReady = false;
    public bool canBeAsked = true;
    public ThoughtCreator thoughts;

    public bool isArea = false;

    int clipsIndex = 0;

    public Animator anim;
    public AudioSource source;
    public List<AudioClip> clips = new List<AudioClip>();
    public AudioClip fredUpbeat;

    public Vector2 dirToPlayer;

    void Awake()
    {

    }

    void Start()
    {
        anim = transform.parent.GetComponent<Animator>();
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Goblin"))
        {
            other.transform.GetChild(other.transform.childCount - 1).GetComponent<ThoughtCreator>().currentNPC = this;
            ready = true;
        }
    }

    void OnTriggerExit2D (Collider2D other)
    {
        if (other.CompareTag("Goblin"))
        {
            ready = false;
            other.transform.GetChild(other.transform.childCount - 1).GetComponent<ThoughtCreator>().currentNPC = null;
        }
    }

    void Update()
    {
        if (ready)
        {
            if (Input.GetKeyDown(KeyCode.E) && faceOnInteract)
            {
                dirToPlayer = (CharacterController.theGoblin.transform.position - transform.position).normalized;
                transform.parent.localScale = new Vector3(dirToPlayer.x > 0 ? -0.5f : 0.5f, 0.5f, 1);
            }
        }

        if (speaking)
        {
            if (source.isPlaying)
            {
                anim.SetFloat("Blend", 1);
            }
            else
            {
                clipsIndex++;
                if (clipsIndex >= clips.Count)
                {
                    anim.SetFloat("Blend", 0);
                    source.Play();
                    speaking = false;
                    transform.parent.localScale = new Vector3(0.5f, 0.5f, 1);
                    if (isAngry)
                        angrySpokenTo = true;
                }
                else
                {
                    source.PlayOneShot(clips[clipsIndex]);
                }
            }
        }
        if (angrySpokenTo && isFred)
        {
            //transform.parent.position = fredPose2;
            anim.SetBool("SecondState", true);
            canBeAsked = true;
            firstLineSpoken = true;
            faceOnInteract = false;
            secondLineReady = true;
        }
        if (angrySpokenTo && isArea)
        {
            if (thoughts.thoughts.Count == 2)
                thoughts.thoughts.RemoveAt(0);
        }
    }

    public void Interact()
    {
        if (canBeAsked)
        {
            if (!done && !firstLineSpoken)
            {
                thoughts.Speak(0);
                source.Stop();
                speaking = true;
                //if (!hasSecondLine)
                canBeAsked = false;
            }
            else if (hasSecondLine && secondLineReady)
            {
                StartCoroutine(FredSitTalk());
                thoughts.Speak(1);
            }
        }
    }    

    IEnumerator FredSitTalk()
    {
        source.PlayOneShot(fredUpbeat);
        anim.SetFloat("Blend", 1);
        canBeAsked = false;
        yield return new WaitForSeconds(2f);
        anim.SetFloat("Blend", 0);
    }
}
