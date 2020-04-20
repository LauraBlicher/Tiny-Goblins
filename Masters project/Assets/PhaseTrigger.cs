using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

[RequireComponent(typeof(BoxCollider2D))]
public class PhaseTrigger : MonoBehaviour
{
    public WalkInFrontHandler handler;
    public enum EntryDirection { Up, Down, Left, Right }
    public EntryDirection entryDirection = EntryDirection.Down;
    public BoxCollider2D col;

    // Start is called before the first frame update
    void Start()
    {
        col = GetComponent<BoxCollider2D>();
        col.isTrigger = true;
        handler = transform.parent.GetComponent<WalkInFrontHandler>();    
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerStay2D(Collider2D other)
    {
        if (other.CompareTag("Goblin"))
        {
            switch (entryDirection)
            {
                case EntryDirection.Down:
                    if (Input.GetAxis("Vertical") < 0)
                        handler.isInFront = true;
                    break;
                case EntryDirection.Up:
                    if (Input.GetAxis("Vertical") > 0 || Input.GetButton("Jump"))
                    {
                        handler.isInFront = true;
                    }
                    break;
                case EntryDirection.Left:
                    if (Input.GetAxis("Horizontal") < 0)
                        handler.isInFront = true;
                    break;
                case EntryDirection.Right:
                    if (Input.GetAxis("Horizontal") > 0)
                        handler.isInFront = true;
                    break;
            }
        }
    }
}
