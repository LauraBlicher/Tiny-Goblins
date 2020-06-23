using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransitionHandler : MonoBehaviour
{
    public bool active = false;
    public bool isIgnored = false;
    public LayerMask groundMask;
    private TransitionLocation currentLocation;
    [Range (0,2)]
    public float checkOffset = 1;
    bool ready = true;
    float t = 0;
    float t1 = 0;
    public bool transitioning = false;
    bool flag = false;
     bool down = false;
    public bool transitionOnEnter = false;

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
                        hit.collider.gameObject.layer = 9;
                        currentLocation.isIgnored = false;
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
                    currentLocation.isIgnored = true;
                    currentLocation.obj.layer = 11;
                    //transform.position = new Vector3(transform.position.x, transform.position.y, currentLocation.objBelow.transform.position.z);
                }
            }
        }
    }

    void Transition()
    {
        float y = currentLocation.start.position.y - currentLocation.end.position.y;
        t1 = (currentLocation.start.position.y - transform.position.y) / y;

        //t1 = Mathf.Clamp01(t1);
        //float newZ = Mathf.Lerp(down ? currentLocation.obj.transform.position.z : currentLocation.objBelow.transform.position.z,
        //    down ? currentLocation.objBelow.transform.position.z : currentLocation.obj.transform.position.z, t1);
        //print(newZ);
        float newZ = Mathf.Lerp(currentLocation.obj.transform.position.z, currentLocation.objBelow.transform.position.z, t1);
        //print(newZ);

        transform.position = new Vector3(transform.position.x, transform.position.y, newZ);

        
    }
}
