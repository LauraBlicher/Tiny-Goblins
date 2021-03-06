﻿using System.Collections;
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
    public bool render = false;

    public bool flipped = false;
    public LayerMask groundMask;
    public LayerMask ignoreMask;
    public Vector3 hitPoint;
    public Vector3 avgPosition;

    public float aimDistance;
    public bool validAim;
    public Material mat;

    public bool transition;
    private bool flag;
    public Vector3 transitionPoint;
    public Vector3 transitionStart;

    void Awake()
    {
        lr = GetComponent<LineRenderer>();
        g = Mathf.Abs(Physics2D.gravity.y);
    }

    // Start is called before the first frame update
    void Start()
    {
        mat = lr.material;
    }

    // Update is called once per frame
    void Update()
    {
        if (render)
            RenderArc();
        else
            lr.enabled = false;

        mat.SetColor("_Color1", validAim ? Color.white : Color.red);
    }

    public void RenderArc()
    {
        validAim = true;
        lr.enabled = true;
        lr.positionCount = resolution + 1;
        lr.SetPositions(ArcArray());
        aimDistance = Vector2.Distance(frog.position, hitPoint);
        if (validAim)
        {
            if (aimDistance <= frog.GetComponent<FrogScript>().minJumpDistanceBeforeCancel)
            {
                validAim = false;
            }
            else
            {
                validAim = true;
            }
        }
    }

    public Vector3[] ArcArray()
    {
        List<Vector3> output = new List<Vector3>(); //Vector3[resolution + 1];
        angleRadians = Mathf.Deg2Rad * (flipped ? -angle : angle);
        float maxDist = (velocity * velocity * Mathf.Sin(2 * angleRadians)) / g;

        flag = false;
        for (int i = 0; i < resolution + 20; i++)
        {
            float t = (float)i / (float)resolution;
            float t2 = ((float)i + 1) / (float)resolution;

            TransitionTest(frog.position + ArcPoint(t, maxDist), frog.position + ArcPoint(t2, maxDist));

            ArcPoint point = TestGroundHit(frog.position + ArcPoint(t, maxDist), frog.position + ArcPoint(t2, maxDist));
            if (i < resolution + 10)
            {
                if (!point.hitGround)
                {
                    output.Add(point.point);
                }
                else
                {
                    output.Add(point.point);
                    output.Add(point.hitPoint);
                    hitPoint = point.hitPoint;
                    break;
                }
            }
            else
            {
                output.Add(point.point);
                hitPoint = point.point;
            }
        }
        Vector3 avg= Vector3.zero;
        foreach(Vector3 point in output)
        {
            avg += point;
        }
        if (!flag)
            transition = false;
        avgPosition = avg / output.Count;
        lr.positionCount = output.Count;
        frog.GetComponent<FrogScript>().expectedLandingPoint = hitPoint;
        return output.ToArray();
    }

    public Vector3 ArcPoint(float t, float maxDist)
    {
        float x = t * maxDist;
        float y = x * Mathf.Tan(angleRadians) - ((g * x * x) / (2 * velocity * velocity * Mathf.Cos(angleRadians) * Mathf.Cos(angleRadians)));
        return new Vector3(x, y, -1f);
    }

    public ArcPoint TestGroundHit(Vector3 start, Vector3 end)
    {
        RaycastHit2D rhit;
        Vector3 dir = (end - start).normalized;
        float dst = Vector3.Distance(start, end);
        rhit = Physics2D.Raycast(start, dir, dst, groundMask);
        Debug.DrawRay(start, dir * dst);
        if (!rhit.collider)
        {
            return new ArcPoint(false, start);
        }
        else
        {
            if (rhit.collider.CompareTag("NoFly"))
                validAim = false;
            return new ArcPoint(true, start, rhit.point);
        }
    }

    public void TransitionTest(Vector2 start, Vector2 end)
    {
        if (!flag)
        {
            Vector2 dir = (end - start).normalized;
            float dst = Vector2.Distance(start, end);
            RaycastHit2D h = Physics2D.Raycast(start, dir, dst, ignoreMask);
            if (h.collider)
            {
                flag = true;
                transition = true;
                transitionPoint = (Vector3)h.point + Vector3.forward * h.collider.transform.position.z;
                transitionStart = transform.position;
            }
        }

    }
}

public class ArcPoint
{
    public bool hitGround;
    public Vector3 point;
    public Vector3 hitPoint;

    public ArcPoint(bool _hitGround, Vector3 _point)
    {
        hitGround = _hitGround;
        point = _point;
    }

    public ArcPoint(bool _hitground, Vector3 _point, Vector3 _hitPoint)
    {
        hitGround = _hitground;
        point = _point;
        hitPoint = _hitPoint;
    }
}
