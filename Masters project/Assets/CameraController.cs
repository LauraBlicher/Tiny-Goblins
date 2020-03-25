using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public Transform characterToFollow;
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
        goblinVelocity = characterToFollow.GetComponent<CharacterController>().velocity.normalized;
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        targetPos = new Vector3((characterToFollow.position + (goblinVelocity * forwardOffset)).x, 0, -21);
        transform.position = new Vector3(Mathf.Lerp(transform.position.x, targetPos.x, lerpSpeed * Time.deltaTime), characterToFollow.position.y, -21);
    }
}
