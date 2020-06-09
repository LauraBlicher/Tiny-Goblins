using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeafMovement : MonoBehaviour
{
    private Vector3 startPosition;
    private Vector3 currentPosition;
    private Vector3 nextPosition;
    [Range(0.1f, 2)]
    public float strength = 1;
    [Range(0.1f, 1)]
    public float speed = 0.5f;

    private float t = 0; 

    void Awake()
    {
        startPosition = transform.position;
        currentPosition = startPosition;
    }

    void Update()
    {
        if (t == 0)
            GenerateNextPosition();

        transform.position = Vector3.Lerp(currentPosition, nextPosition, t);
        t += speed * Time.deltaTime;
        t = Mathf.Clamp01(t);
        if (t >= 1)
        {
            currentPosition = transform.position;
            t = 0;
        }
    }

    public void GenerateNextPosition()
    {
        nextPosition = (Vector2)startPosition + Random.insideUnitCircle * strength;
    }
}
