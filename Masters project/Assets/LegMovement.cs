using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LegMovement : MonoBehaviour
{
    public float maxDist = 1f, maxDistSprint = 2f, minDistBetweenFeet = 0.5f;
    public Transform frontJoint, backJoint;
    public GameObject foot1, foot2, foot3, foot4;
    public LayerMask groundMask;
    public List<Foot> feet = new List<Foot>();
    public float secondsToMoveFoot = 1f;
    public float movementSpeed = 1f, sprintSpeed = 2f;
    public Vector2 velocity;
    private Vector2 oldPos, newPos;
    public bool sprinting = false;

    private float idleTimer = 0;
    public bool idle;

    // Start is called before the first frame update
    void Start()
    {
        oldPos = transform.position;
        feet.Add(new Foot(foot1, frontJoint, true, foot1.GetComponent<LineRenderer>())); feet.Add(new Foot(foot2, frontJoint, true, foot2.GetComponent<LineRenderer>()));
        feet.Add(new Foot(foot3, backJoint, false, foot3.GetComponent<LineRenderer>())); feet.Add(new Foot(foot4, backJoint, false, foot4.GetComponent<LineRenderer>()));
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        sprinting = Input.GetKey(KeyCode.LeftShift);
        transform.Translate(new Vector2(Input.GetAxis("Horizontal") * (sprinting ? sprintSpeed : movementSpeed) * Time.deltaTime, 0));

        UpdateJointHeight(frontJoint, foot1, foot2);
        UpdateJointHeight(backJoint, foot3, foot4);

        velocity = CalculateVelocity();
        
        if (velocity.x == 0)
        {
            idleTimer += Time.deltaTime;
            idle = (idleTimer > 2);
        }
        else
        {
            idleTimer = 0;
            idle = false;
        }

        foreach(Foot f in feet)
        {
            f.lr.SetPosition(0, f.foot.transform.position);
            f.lr.SetPosition(1, f.joint.position);
            if (!f.isMoving)
            {
                if (OtherFootIsBehind(f))
                {
                    f.oldPos = f.newPos;
                    f.newPos = NewFootPosition(f);
                    f.isMoving = true;
                    f.t = 0;
                }
                else if (idle)
                {
                    Idle(f);
                }
            }
            else
            {
                if (TooCloseToOtherFoot(f))
                {
                    RepickNewFootPosition(f);
                }
                MoveFoot(f, f.t);
                f.t += Time.deltaTime / (sprinting ? secondsToMoveFoot/2 : secondsToMoveFoot);
                if (f.t >= 1)
                {
                    f.isMoving = false;
                }
            }
        }
    }

    public Vector2 CalculateVelocity()
    {
        Vector2 output = Vector2.zero;
        newPos = transform.position;
        output = newPos - oldPos;
        oldPos = newPos;
        return output;
    }

    public void UpdateJointHeight(Transform joint, GameObject f1, GameObject f2)
    {
        float avgY = (f1.transform.position.y + f2.transform.position.y) / 2;
        joint.position = new Vector2(joint.position.x, avgY + maxDist / 3);
    }

    public bool OtherFootIsBehind(Foot foot)
    {
        Foot otherFoot = null;
        bool footIsLeft = (foot.foot.transform.position - foot.joint.position).x < 0;
        bool otherFootIsLeft = false;
        bool fwdIsLeft = velocity.x < 0;
        bool output = false;

        foreach (Foot f in feet)
        {
            if (f.isFront == foot.isFront && f != foot)
                otherFoot = f;
        }

        otherFootIsLeft = (otherFoot.foot.transform.position - otherFoot.joint.position).x < 0;

        bool bothFeetBehind = (footIsLeft && otherFootIsLeft && !fwdIsLeft) || (!footIsLeft && !otherFootIsLeft && fwdIsLeft);
        float dist = foot.foot.transform.position.x - foot.joint.position.x;
        float distOther = otherFoot.foot.transform.position.x - otherFoot.joint.position.x;

        if (bothFeetBehind)
        {
            if (Mathf.Abs(dist) > Mathf.Abs(distOther) && !otherFoot.isMoving)
            {
                output = true;
            }
        }

        return output;
    }

    public bool FootIsTooFar(Foot foot)
    {
        bool footIsLeft = (foot.foot.transform.position - foot.joint.position).x < 0;
        bool fwdIsLeft = velocity.x < 0;
        bool output = false;

        bool footIsBehind = (footIsLeft && !fwdIsLeft) || (!footIsLeft && fwdIsLeft);

        if (!footIsBehind)
        {
            //output = (foot.joint.position - foot.foot.transform.position).sqrMagnitude > Mathf.Pow(maxDist, 2);
            output = false;
        }
        else
        {
            output = (foot.joint.position - foot.foot.transform.position).sqrMagnitude > Mathf.Pow((sprinting ? maxDistSprint * 1.1f : maxDist * 1.1f) * 0.5f, 2);
        }

        if (velocity.x != 0)
            return output;
        else
            return false;
    }

    public Vector2 NewFootPosition(Foot foot)
    {
        Vector2 output = Vector2.zero;
        bool isLeft = (foot.foot.transform.position - foot.joint.position).x < 0;
        int leftMod = isLeft ? 1 : -1;
        RaycastHit2D hit;
        for (int i = 0; i < 10; i++)
        {
            Vector2 dir = new Vector2(Mathf.Lerp(1 * leftMod, 0, 0 + (float)i / 10), Mathf.Lerp(0, -1, 0 + (float)i / 10));
;           hit = Physics2D.Raycast(foot.joint.position, dir, (sprinting ? maxDistSprint*0.9f : maxDist*0.9f), groundMask);
            if (hit.collider)
            {
                output = hit.point;
                break;
            }
        }
        return output;
    }

    public void RepickNewFootPosition(Foot foot)
    {
        Vector2 newPos = foot.newPos;
        Foot otherFoot = null;
        RaycastHit2D hit;
        Vector2 dir;
        foreach (Foot f in feet)
        {
            if (f.isFront == foot.isFront && f != foot)
                otherFoot = f;
        }
        if (otherFoot != null)
        {
            for (int i = 0; i < 1000; i++)
            {
                newPos = foot.newPos + Random.insideUnitCircle * (2 * minDistBetweenFeet);
                dir = (newPos - (Vector2)foot.joint.position).normalized;
                hit = Physics2D.Raycast(foot.joint.position, dir, maxDist, groundMask);
                if (hit.collider)
                {
                    if ((hit.point - otherFoot.newPos).sqrMagnitude > minDistBetweenFeet * minDistBetweenFeet)
                    {
                        newPos = hit.point;
                        break;
                    }
                }
            }
        }
        foot.newPos = newPos;
    }

    public bool TooCloseToOtherFoot(Foot foot)
    {
        bool output = false;
        Foot otherFoot = null;
        foreach(Foot f in feet)
        {
            if (f.isFront == foot.isFront && f != foot)
                otherFoot = f;
        }

        if (otherFoot != null)
        {
            if ((foot.newPos - otherFoot.newPos).sqrMagnitude < minDistBetweenFeet * minDistBetweenFeet)
            {
                if (foot.t < otherFoot.t)
                    output = true;
            }
        }

        return output;
    }

    public void MoveFoot(Foot foot, float t)
    {
        float yBonus = 0f;
        if (t < 0.5f)
        {
            yBonus = t;
        }
        else
        {
            yBonus = 0.5f - (t - 0.5f);
        }
        foot.foot.transform.position = Vector2.Lerp(foot.oldPos, foot.newPos, t) + new Vector2(0, yBonus);
    }

    public void Idle(Foot foot)
    {
        Vector2 groundPos = Vector2.zero;
        RaycastHit2D hit = Physics2D.Raycast(foot.joint.position, Vector2.down, Mathf.Infinity, groundMask);
        if (hit.collider)
        {
            groundPos = hit.point;
        }
        Vector2 newPos = groundPos + Random.insideUnitCircle * minDistBetweenFeet * 2;
        Vector2 dir = (newPos - (Vector2)foot.joint.position).normalized;
        hit = Physics2D.Raycast(foot.joint.position, dir, maxDist, groundMask);
        //if (hit.collider)
        //{
        //    newPos = hit.point;
        //}
        //else
        //{
            newPos = groundPos;
        //}
        foot.oldPos = foot.newPos;
        foot.newPos = newPos;
        foot.isMoving = true;
    }
}

public class Foot
{
    public GameObject foot;
    public Transform joint;
    public bool isMoving;
    public Vector2 newPos, oldPos;
    public float t = 0;
    public LineRenderer lr;
    public bool isFront;

    public Foot(GameObject _foot, Transform _joint, bool _isFront, LineRenderer _lr)
    {
        foot = _foot;
        joint = _joint;
        newPos = foot.transform.position;
        isFront = _isFront;
        lr = _lr;
    }
}
