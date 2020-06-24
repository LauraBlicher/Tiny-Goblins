using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using System;

public class TransitionHandler : MonoBehaviour
{
    public static TransitionHandler instance;
    public bool active = false;
    public bool isIgnored = false;
    public LayerMask groundMask;
    private TransitionLocation currentLocation;
    [Range (0,2)]
    public float checkOffset = 1;
    bool ready = true;
    float t = 0;
    public float t1 = 0;
    public bool transitioning = false;
    bool flag = false;
     bool down = false;
    public bool transitionOnEnter = false;

    public SortingGroup gGroup, fGroup;

    public event Action transitionEvent;

    void Awake()
    {
        instance = this;
    }

    void Start()
    {
        gGroup = GetComponent<SortingGroup>();
        fGroup = FrogScript.instance.GetComponent<SortingGroup>();
    }

    public void OnTriggerStay2D (Collider2D other)
    {
        if (ready)
        {
            if (other.CompareTag("Transition"))
            {
                active = true;
                currentLocation = other.transform.parent.GetComponent<TransitionLocation>();
                isIgnored = currentLocation.isIgnored;
                transitionOnEnter = currentLocation.transitionOnEnter;
            }
        }
    }

    public void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Transition"))
        {
            active = false;
            currentLocation = null;
            ready = true;
            t = 0;
        }
    }

    void Update()
    {
        if (!GetComponent<CharacterController>().isMounted)
        {
            if (!currentLocation)
            {                
                transitioning = false;
            }

            if (transitioning)
            {
                if (t1 > 1)
                {
                    transitioning = false;
                    // t1 = 0;
                }
                else
                    Transition();
            }
            //Debug.DrawRay((Vector2)transform.position + Vector2.down * checkOffset, -transform.up * 10, Color.cyan);
            if (!ready && !transitioning)
            {
                t += Time.deltaTime;
                if (t >= 1)
                {
                    ready = true;
                }
            }
            if (active && isIgnored)
            {
                if (Input.GetKeyDown(KeyCode.Space) || transitionOnEnter)
                    flag = true;
                if (flag)
                {
                    t1 = 0;
                    transitioning = true;
                    down = false;
                    RaycastHit2D hit = Physics2D.Raycast((Vector2)transform.position + Vector2.down * checkOffset, -transform.up, Mathf.Infinity, groundMask);
                    if (hit.collider.gameObject.layer == 11 && hit.distance > 0.1f && hit.distance < 1)
                    {
                        transitionEvent.Invoke();
                        

                        gGroup.sortingLayerName = "GoblinMiddle";
                        fGroup.sortingLayerName = "GoblinMiddle";
                        //hit.collider.gameObject.layer = 9;
                        //currentLocation.isIgnored = false;
                        ready = false;
                        active = false;
                        transitioning = false;
                        //transform.position = new Vector3(transform.position.x, transform.position.y, currentLocation.obj.transform.position.z);
                        t = 0;
                    }
                }
            }
            else if (active && !isIgnored)
            {
                if (Input.GetKeyDown(KeyCode.S))
                {
                    ready = false;
                    transitioning = true;
                    active = false;
                    down = true;
                    t1 = 0;
                    t = 0;

                    gGroup.sortingLayerName = "GoblinFront";
                    fGroup.sortingLayerName = "GoblinFront";
                    transitionEvent.Invoke();
                    //currentLocation.isIgnored = true;

                    //currentLocation.obj.layer = 11;

                    //transform.position = new Vector3(transform.position.x, transform.position.y, currentLocation.objBelow.transform.position.z);
                }
            }
        }
        else
        {
            if (transitioning)
                Transition();
            RaycastHit2D hit = Physics2D.Raycast((Vector2)transform.position + Vector2.down * checkOffset, Vector3.down, 10, groundMask);
            if (hit.collider)
            {
                if (hit.collider.gameObject.layer == 11 && hit.distance > 0.1f && hit.distance < 1)
                {
                    gGroup.sortingLayerName = "GoblinMiddle";
                    fGroup.sortingLayerName = "GoblinMiddle";
                    transitionEvent.Invoke();
                    //hit.collider.gameObject.layer = 9;
                    //currentLocation.isIgnored = false;
                    ready = false;
                    active = false;
                    transitioning = false;
                    //transform.position = new Vector3(transform.position.x, transform.position.y, currentLocation.obj.transform.position.z);
                    t = 0;
                }
            }
        }
    }

    void Transition()
    {
        float newZ = 0;
        if (!GetComponent<CharacterController>().isMounted)
        {
            float y = currentLocation.start.position.y - currentLocation.end.position.y;
            t1 = (currentLocation.start.position.y - transform.position.y) / y;
            newZ = Mathf.Lerp(currentLocation.obj.transform.position.z, currentLocation.objBelow.transform.position.z, t1);
            
        }
        else
        {
            ArcRenderer arc = FrogScript.instance.arc;
            float y = arc.transitionStart.y - arc.transitionPoint.y;
            t1 = (arc.transitionStart.y - transform.position.y) / y;
            newZ = Mathf.Lerp(arc.transitionStart.z, arc.transitionPoint.z, t1);

            FrogScript.instance.transform.position = new Vector3(FrogScript.instance.transform.position.x, FrogScript.instance.transform.position.y, newZ);
        }


        transform.position = new Vector3(transform.position.x, transform.position.y, newZ);        
    }
}
