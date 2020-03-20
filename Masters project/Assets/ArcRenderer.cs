using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(LineRenderer))]
public class ArcRenderer : MonoBehaviour
{
    public Transform frog;
    LineRenderer lr;
    float g;
    public float angle;
    public float velocity;
    public int resolution;
    float angleRadians;


    void Awake()
    {
        lr = GetComponent<LineRenderer>();
        g = Mathf.Abs(Physics2D.gravity.y);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        RenderArc();
    }

    public void RenderArc()
    {
        lr.positionCount = resolution + 1;
        lr.SetPositions(ArcArray());
    }

    public Vector3[] ArcArray()
    {
        Vector3[] output = new Vector3[resolution + 1];
        angleRadians = Mathf.Deg2Rad * angle;
        float maxDist = (velocity * velocity * Mathf.Sin(2 * angleRadians)) / g;

        for (int i = 0; i < resolution + 1; i++)
        {
            float t = (float)i / (float)resolution;
            output[i] = frog.position + ArcPoint(t, maxDist);
        }

        return output;
    }

    public Vector3 ArcPoint(float t, float maxDist)
    {
        float x = t * maxDist;
        float y = x * Mathf.Tan(angleRadians) - ((g * x * x) / (2 * velocity * velocity * Mathf.Cos(angleRadians) * Mathf.Cos(angleRadians)));
        return new Vector3(x, y, -1f);
    }
}
