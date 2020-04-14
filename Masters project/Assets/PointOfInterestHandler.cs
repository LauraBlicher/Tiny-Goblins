using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PointOfInterestHandler : MonoBehaviour
{
    private Transform child;
    public float camSize;
    public float distForTrigger;
    public bool testDistance = false;
    public float currentDistToPlayer;
    public bool useOffset = false;
    public Vector2 offset;
    public bool playerIsCloseEnough = false;
    
    // Start is called before the first frame update
    void Start()
    {
        
        if (!CameraController.pois.Contains(this))
        {
            CameraController.pois.Add(this);
        }
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (testDistance)
            currentDistToPlayer = Vector2.Distance(transform.position, CharacterController.theGoblin.transform.position);
        playerIsCloseEnough = (CharacterController.theGoblin.transform.position - transform.position).sqrMagnitude <= distForTrigger * distForTrigger;
    }

    void OnValidate()
    {
        if (!child)
        {
            child = transform.GetChild(0);
        }
        offset = transform.position + child.localPosition;
    }

    void OnDrawGizmos()
    {
        Gizmos.DrawWireSphere(transform.position, distForTrigger);
        Gizmos.DrawWireCube(useOffset ? child.transform.position : transform.position, new Vector3(camSize * 3.5f, camSize * 2f, 1));
    }
}
