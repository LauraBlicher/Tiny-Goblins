using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LegAnimator : MonoBehaviour
{
    public Transform frontTarget, backTarget, feet;
    public Vector3 direction;
    public LayerMask groundMask;
    public CharacterController goblin;
    public float maxDist = 2;
    public float forwardStepDistance = 1;
    public float distBetweenPoints = 1;
    public AnimationCurve curve;
    private Vector3 frontTargetPoint, backTargetPoint;
    private Vector3 prevFrontPoint, prevBackPoint;
    private float frontT, backT;
    private bool frontStarted, backStarted, frontLifted, backLifted;
    public float animationSpeed = 4f;
    private bool moveFrontLeg, moveBackLeg;
    public float frontDist, backDist;
    private bool frontBehind, backBehind;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        frontDist = Vector2.Distance(frontTarget.position, feet.position);
        backDist = Vector2.Distance(backTarget.position, feet.position);
        Debug.DrawLine(feet.position, backTargetPoint);
        Debug.DrawLine(feet.position, frontTargetPoint);
        direction = goblin.walkDir.normalized;
        backBehind = ((backTarget.position - feet.position).normalized.x > 0 && direction.x < 0) ||
            ((backTarget.position - feet.position).normalized.x < 0 && direction.x > 0);
        frontBehind = ((frontTarget.position - feet.position).normalized.x > 0 && direction.x < 0) ||
            ((frontTarget.position - feet.position).normalized.x < 0 && direction.x > 0);

        MaintainDistance();

        if (frontDist > maxDist && frontBehind)
        {
            moveFrontLeg = true;
        }
        if (backDist > maxDist && backBehind)
        {
            moveBackLeg = true;
        }

        if (moveFrontLeg)
        {
            AnimateMovementFront();
        }
        if (moveBackLeg)
        {
            AnimateMovementBack();
        }
    }

    public void MaintainDistance()
    {
        if (Vector2.Distance(frontTargetPoint, backTargetPoint) < distBetweenPoints)
        {
            frontTargetPoint += (frontTargetPoint - backTargetPoint).normalized * Time.deltaTime + (Vector3.right * 0.1f);
            backTargetPoint += (backTargetPoint - frontTargetPoint).normalized * Time.deltaTime + (Vector3.left * 0.1f);
        }
    }

    public void AnimateMovementFront()
    {        
        if (!frontStarted)
        {
            prevFrontPoint = frontTargetPoint;
            frontStarted = true;
            frontT = 0;
            frontTargetPoint = SetNewTargetPoint();
        }
        float yT = curve.Evaluate(frontT);
        if (!frontLifted)
        {
            frontTarget.position = new Vector3(
                Mathf.Lerp(prevFrontPoint.x, frontTargetPoint.x, frontT),
                Mathf.Lerp(prevFrontPoint.y, feet.position.y, yT));
            if (frontT >= 0.5f)
            {
                frontLifted = true;
            }
        }
        else
        {
            frontTarget.position = new Vector3(
                Mathf.Lerp(prevFrontPoint.x, frontTargetPoint.x, frontT),
                Mathf.Lerp(frontTargetPoint.y, feet.position.y, yT));
        }
        if(frontT >= 1)
        {
            moveFrontLeg = false;
            frontStarted = false;
        }
        frontT += animationSpeed * Time.deltaTime;
    }
    public void AnimateMovementBack()
    {        
        if (!backStarted)
        {
            prevBackPoint = backTargetPoint;
            backStarted = true;
            backT = 0;
            backTargetPoint = SetNewTargetPoint();
        }
        float yT = curve.Evaluate(backT);
        if (!backLifted)
        {
            backTarget.position = new Vector3(
                Mathf.Lerp(prevBackPoint.x, backTargetPoint.x, backT),
                Mathf.Lerp(prevBackPoint.y, feet.position.y, yT));
            if (backT >= 0.5f)
            {
                backLifted = true;
            }
        }
        else
        {
            backTarget.position = new Vector3(
                Mathf.Lerp(prevBackPoint.x, backTargetPoint.x, backT),
                Mathf.Lerp(backTargetPoint.y, feet.position.y, yT));
        }
        if (backT >= 1)
        {
            moveBackLeg = false;
            backStarted = false;
        }
        backT += animationSpeed * Time.deltaTime;
    }

    public Vector3 SetNewTargetPoint()
    {
        RaycastHit2D hit;
        Vector3 rayDir = ((goblin.groundPoint + direction * forwardStepDistance) - feet.position).normalized;
        hit = Physics2D.Raycast(feet.position, rayDir, Mathf.Infinity, groundMask);
        if (hit.collider)
        {
            return hit.point;
        }
        else
        {
            return Vector3.zero;
        }
    }
}
