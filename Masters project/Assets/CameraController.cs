using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform goblinToFollow;
    public float forwardOffset = 1;
    public float lerpSpeed = 2;

    private Vector3 goblinVelocity;
    private Vector3 targetPos;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void Update()
    {
        goblinVelocity = goblinToFollow.GetComponent<CharacterController>().velocity.normalized;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        targetPos = new Vector3((goblinToFollow.position + (goblinVelocity * forwardOffset)).x, transform.position.y, -10);
        transform.position = Vector3.Lerp(transform.position, targetPos, lerpSpeed * Time.deltaTime);
    }
}
