using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(PolygonCollider2D))]
public class WalkInFrontHandler : MonoBehaviour
{
    public List<Collider2D> colliders = new List<Collider2D>();

    public Collider2D checkCol;

    public bool isInFront;

    // Start is called before the first frame update
    void Start()
    {
        checkCol = GetComponent<Collider2D>();
        checkCol.enabled = false;
        checkCol.isTrigger = true;
    }

    // Update is called once per frame
    void Update()
    {
        foreach(Collider2D col in colliders)
        {
            col.isTrigger = isInFront;
            col.gameObject.layer = isInFront ? 0 : 9;
        }

        checkCol.enabled = isInFront;
    }

    public void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Goblin"))
        {
            isInFront = false;
        }
    }
}
