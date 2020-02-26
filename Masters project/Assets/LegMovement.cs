using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LegMovement : MonoBehaviour
{
    // REWRITE  - legs never stretch beyond their max length
    //          - Run makes both legs let go
    //          - More modular, so the number of legs can be asigned
    //          - Legs hold their infomation, including length
    //          - Each joint knows its down dir
    public List<GameObject> footGameObjects = new List<GameObject>();
    public List<GameObject> jointGameObjects = new List<GameObject>();
    public float maxDist = 1f, maxDistSprint = 2f, minDistBetweenFeet = 0.5f;
    public Transform frontJoint, backJoint;
    public GameObject foot1, foot2, foot3, foot4;
    public LayerMask groundMask;
    public List<Foot> feet = new List<Foot>();
    public float legLiftHeight = 1f, legLiftOverObject = .5f;
    public float secondsToMoveFoot = 1f;
    public float movementSpeed = 1f, sprintSpeed = 2f;
    public Vector2 velocity;
    private Vector2 oldPos, newPos;
    public bool sprinting = false;

    public AnimationCurve curve;

    private float idleTimer = 0;
    public bool idle;

    public AnimationCurve displayXCurve;

    private List<PathNode> path = new List<PathNode>();

    // Start is called before the first frame update
    void Start()
    {
        oldPos = transform.position;

        int index = 0;
        bool flag = false;
        for (int i = 0; i < footGameObjects.Count; i++)
        {
            feet.Add(new Foot(index, footGameObjects[i], jointGameObjects[i].transform, footGameObjects[i].GetComponent<LineRenderer>()));
            if (!flag)
            {
                flag = !flag;
            }
            else
            {
                flag = !flag;
                index++;
            }
            print(feet[i].index);
        }
        //feet.Add(new Foot(foot1, frontJoint, true, foot1.GetComponent<LineRenderer>())); feet.Add(new Foot(foot2, frontJoint, true, foot2.GetComponent<LineRenderer>()));
        //feet.Add(new Foot(foot3, backJoint, false, foot3.GetComponent<LineRenderer>())); feet.Add(new Foot(foot4, backJoint, false, foot4.GetComponent<LineRenderer>()));
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        sprinting = Input.GetKey(KeyCode.LeftShift);
        transform.Translate(new Vector2(Input.GetAxis("Horizontal") * (sprinting ? sprintSpeed : movementSpeed) * Time.deltaTime, 0));

        UpdateJointHeight();

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
                if (OtherFootIsBehind(f) || FootIsTooFar(f))
                {
                    f.oldPos = f.foot.transform.position; // f.newPos;
                    f.newPos = NewFootPosition(f);
                    CreatePath(f);
                    f.isMoving = true;
                    f.t = 0;
                }
                else if (idle)
                {
                    //Idle(f);
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

    public void UpdateJointHeight()
    {
        Vector2 lowestPoint = Vector2.zero;
        lowestPoint = feet[0].foot.transform.position;
        for (int i = 0; i < feet.Count; i++)
        {
            for (int j = 0; j < feet.Count; j++)
            {
                if(feet[j].foot.transform.position.y < lowestPoint.y)
                {
                    lowestPoint = feet[j].foot.transform.position;
                }
            }
        }
        foreach (Foot f in feet)
        {
            Vector2 newPos = new Vector2(f.joint.position.x, lowestPoint.y + maxDist * 0.8f);
            f.joint.position = newPos;
        }
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
            if (f.index == foot.index && f != foot)
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
            output = (foot.joint.position - foot.foot.transform.position).sqrMagnitude > Mathf.Pow((sprinting ? maxDistSprint * 1.1f : maxDist * 1.1f) * 0.9f, 2);
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
            Vector2 dir; // = new Vector2(Mathf.Lerp(1 * leftMod, 0, 0 + (float)i / 10), Mathf.Lerp(0, -1, 0 + (float)i / 10));
            dir = sprinting ? Quaternion.Euler(0, 0, 45 *-leftMod) * Vector3.right * leftMod : Quaternion.Euler(0, 0, 55 * -leftMod) * Vector3.right * leftMod;
            hit = Physics2D.Raycast(foot.joint.position, dir, Mathf.Infinity, groundMask); // Physics2D.Raycast(foot.joint.position, dir, (sprinting ? maxDistSprint*0.9f : maxDist*0.9f), groundMask);
            Debug.DrawRay(foot.joint.position, dir * 10);
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
            if (f.index == foot.index && f != foot)
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
            if (f.index == foot.index && f != foot)
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

    public void CreatePath(Foot foot)
    {
        path.Clear();
        foot.path.Clear();
        path.Add(new PathNode(foot.oldPos, 0));
        foot.x = new AnimationCurve();
        foot.y = new AnimationCurve();

        Vector2 dirToDestination, newDir, oldPoint = foot.oldPos, newPoint;
        float distToDestination;
        RaycastHit2D hit;
        int iterations = 0, maxIterations = 1000;
        while (Physics2D.Raycast(path[path.Count-1].point, (foot.newPos - path[path.Count-1].point).normalized, Vector2.Distance(path[path.Count-1].point, foot.newPos), groundMask))
        {
            iterations++;
            if (iterations >= maxIterations || path[path.Count-1].point == foot.newPos)
                break;
            dirToDestination = (foot.newPos - path[path.Count - 1].point).normalized;
            distToDestination = Vector2.Distance(path[path.Count - 1].point, foot.newPos);
            hit = Physics2D.Raycast(path[path.Count - 1].point, dirToDestination, distToDestination, groundMask);
            if (hit.collider)
            {
                newPoint = hit.point;
                for (int i = 0; i < 100; i++)
                {
                    oldPoint = newPoint;
                    newDir = Quaternion.Euler(0, 0, 5f) * dirToDestination;
                    hit = Physics2D.Raycast(path[path.Count - 1].point, dirToDestination, distToDestination, groundMask);
                    if (hit.collider)
                    {
                        if ((hit.point - foot.newPos).sqrMagnitude > 0.01f)
                            newPoint = hit.point + new Vector2(0, legLiftOverObject);
                        else
                        {
                            newPoint = foot.newPos;
                            oldPoint = foot.newPos;
                            break;
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }
            path.Add(new PathNode(oldPoint, Vector2.Distance(path[path.Count-1].point, oldPoint)));
        }
        if (path.Count == 1)
        {
            path.Add(new PathNode(foot.newPos, Vector2.Distance(foot.oldPos, foot.newPos)));
        }
        
        print(path.Count);
        float totalDist = 0;
        float points = 0;
        if (path.Count > 1)
        {
            foreach (PathNode p in path)
            {
                totalDist += p.distance;
            }
            for (int i = 0; i < path.Count; i++)
            {
                path[i].percentOfPath = path[i].distance / totalDist;
                points += path[i].percentOfPath;
                path[i].percentPointInPath = points;
            }
        }
        foot.path = path;
        if (foot.path.Count > 0)
        {
            for (int i = 0; i < foot.path.Count; i++)
            {
                PathNode p = foot.path[i];
                foot.x.AddKey(new Keyframe(p.percentPointInPath, p.point.x));
                foot.y.AddKey(new Keyframe(p.percentPointInPath, p.point.y));
            }
            for (int i = 0; i < foot.x.keys.Length; i++)
            {
                foot.x.SmoothTangents(i, 0);
            }
            for (int i = 0; i < foot.y.keys.Length; i++)
            {
                foot.y.SmoothTangents(i, 0);
            }
        }
    }

    public void MoveFoot(Foot foot, float t)
    {
        for (int i = 0; i < foot.path.Count-1; i++)
        {
            Debug.DrawLine(foot.path[i].point, foot.path[i + 1].point, Color.red);
        }
        Vector2 nextPos = Vector2.zero;
        float yBonus = 0f; // curve.Evaluate(t);
        if (foot.x != null && foot.y != null)
        {
            nextPos = new Vector2(foot.x.Evaluate(t), foot.y.Evaluate(t)) + new Vector2(0, yBonus);
            displayXCurve = foot.x;
        }

        foot.foot.transform.position = nextPos;
        //nextPos = Vector2.Lerp(foot.oldPos, foot.newPos, t);
        //Vector2 dir = (nextPos - (Vector2)foot.joint.position).normalized;
        //Vector2 newPos = Vector2.zero;
        //RaycastHit2D hit = Physics2D.Raycast(foot.joint.position, dir, Mathf.Infinity, groundMask);
        //if (hit.collider)
        //{
        //    newPos = dir * (hit.distance - yBonus);
        //}

        //foot.foot.transform.position = Vector2.Lerp(foot.oldPos, foot.newPos, t) + new Vector2(0, yBonus);
        //foot.foot.transform.position = (Vector2)foot.joint.position + newPos;
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

public class PathNode
{
    public Vector2 point;
    public float percentOfPath;
    public float percentPointInPath;
    public float distance;


    public PathNode(Vector2 _point, float _distance)
    {
        point = _point;
        distance = _distance;
    }
}

public class Foot
{
    public int index;
    public GameObject foot;
    public Transform joint;
    public bool isMoving;
    public Vector2 newPos, oldPos;
    public float t = 0;
    public LineRenderer lr;
    public bool isFront;
    public List<PathNode> path = new List<PathNode>();
    public AnimationCurve x = new AnimationCurve();
    public AnimationCurve y = new AnimationCurve();

    public Foot(int _index, GameObject _foot, Transform _joint, LineRenderer _lr)
    {
        index = _index;
        foot = _foot;
        joint = _joint;
        newPos = foot.transform.position;
        lr = _lr;
    }
}
