﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class FrogScript : MonoBehaviour
{
    public LayerMask groundMask;

    public ArcRenderer arc;
    public Rigidbody2D rb;

    private bool flipped = false;
    private Vector3 frogMidPoint;
    public CapsuleCollider2D col;
    public FrogPositionInfo currentPosition;
    public float velocityMin, velocityMax;
    public float angleMin, angleMax;
    public float scrollSpeed = 1f;
    public bool isGrounded;
    public bool isMounted = false;
    public float movementInput;
    public float jumpDistance;
    public bool canMove;
    public bool canJump;

    float ta = 0, tv = 0;
    float v, a;
    public bool aiming = false;
    Vector3 aimDir;
    public float currentHeight = 1f;
    private float right;
    public float groundAngle;
    public float groundAngleNew;
    private float movementSpeed;
    private Vector3 newRight;
    private Vector3 walkDir;

    public float minHeight = 1f, maxHeight = 1.1f;

    public enum AnimationState { Idle, JumpAim, Flying, Walk }
    public AnimationState currentAnimState = AnimationState.Idle;
    private bool enterState = false;
    public Animator anim;

    void Awake()
    {
        onLanded += CharacterLanded;
    }
    // Start is called before the first frame update
    void Start()
    {
        anim = GetComponent<Animator>();
        currentPosition = new FrogPositionInfo(ClosestGroundPoint(), 0, Vector3.zero);
        col = GetComponent<CapsuleCollider2D>();
        a = angleMin;
        v = velocityMin;
        arc.velocity = v;
        arc.angle = a;
    }

    // Update is called once per frame
    void Update()
    {
        frogMidPoint = col.bounds.center;
        if (rb.velocity.y < 0)
            CharacterLandedTrigger();

        UpdatePositionInfo();
        if (isGrounded)
        {
            MaintainHeight();
        }
        if (isMounted)
        {
            AnimationStateMachine();
            movementInput = canMove ? Input.GetAxis("Horizontal") : 0;
            right = flipped ? 1 : -1;
            movementSpeed = isGrounded ? 2 : 0;

            newRight = Vector3.Cross(currentPosition.dirToGroundPoint, Vector3.back);
            transform.rotation = Quaternion.Lerp(transform.rotation, Quaternion.Euler(RotationFromDir(newRight)), 3*Time.deltaTime);//Quaternion.Euler(0, 0, right * groundAngleNew);
            walkDir = (isGrounded ? newRight : Vector3.right * Mathf.Abs(movementInput)) * (movementInput * movementSpeed * Time.deltaTime);

            currentHeight = currentPosition.distToGroundPoint;

            if (!aiming)
                transform.position += walkDir;

            if (Input.GetKey(KeyCode.Space))
            {
                if (canJump)
                    AimJump();
            }
            else
            {
                if (aiming)
                {
                    CameraController.mainCamController.frogCamOverride = false;
                    rb.gravityScale = 1;
                    canJump = false;

                    arc.render = false;
                    rb.velocity = Vector3.zero;
                    rb.AddForce(aimDir * v, ForceMode2D.Impulse);
                    isGrounded = false;
                    aiming = false;
                }
                else
                {
                    float h = Input.GetAxis("Horizontal");
                    if (h < 0)
                    {
                        flipped = true;
                        transform.localScale = new Vector3(0.5f,0.5f);
                    }
                    else if (h > 0)
                    {
                        flipped = false;
                        transform.localScale = new Vector3(-0.5f, 0.5f);
                    }
                }
            }
            arc.flipped = flipped;
        }
    }

    public void AnimationStateMachine()
    {
        for (int i = 0; i < 4; i++)
        {
            anim.ResetTrigger(i);
        }
        switch (currentAnimState)
        {
            case AnimationState.Idle:
                if (!enterState)
                {
                    anim.SetTrigger("enterIdle");
                    enterState = true;
                }
                if (Input.GetAxis("Horizontal") != 0 && !aiming)
                {
                    enterState = false;
                    currentAnimState = AnimationState.Walk;
                }
                if (aiming)
                {
                    enterState = false;
                    currentAnimState = AnimationState.JumpAim;
                }
                break;
            case AnimationState.JumpAim:
                if (!enterState)
                {
                    anim.SetTrigger("enterAim");
                    enterState = true;
                }
                if (!aiming)
                {
                    enterState = false;
                    currentAnimState = AnimationState.Flying;
                }
                break;
            case AnimationState.Flying:
                if (!enterState)
                {
                    enterState = true;
                    anim.SetTrigger("enterFlying");
                }
                if (isGrounded)
                {
                    enterState = false;
                    currentAnimState = AnimationState.Idle;
                }
                break;
            case AnimationState.Walk:
                if (!enterState)
                {
                    enterState = true;
                    anim.SetTrigger("enterWalk");
                }
                if (aiming)
                {
                    enterState = false;
                    currentAnimState = AnimationState.JumpAim;
                    break;
                }
                if (Input.GetAxis("Horizontal") == 0)
                {
                    enterState = false;
                    currentAnimState = AnimationState.Idle;
                }
                break;
        }
    }

    public void UpdatePositionInfo()
    {
        currentPosition.closestGroundPoint = ClosestGroundPoint();
        currentPosition.dirToGroundPoint = (ClosestGroundPoint() - frogMidPoint).normalized;
        currentPosition.distToGroundPoint = Vector3.Distance(ClosestGroundPoint(), frogMidPoint);
        Debug.DrawRay(frogMidPoint, currentPosition.dirToGroundPoint * currentPosition.distToGroundPoint, Color.yellow);
    }

    public void MaintainHeight()
    {
        if (currentPosition.distToGroundPoint > maxHeight + 0.5f)
        {
            isGrounded = IsGrounded();
        }
        else if(currentPosition.distToGroundPoint > maxHeight)
        {
            transform.position += currentPosition.dirToGroundPoint * Time.deltaTime;
        }
        else if (currentPosition.distToGroundPoint < minHeight)
        {
            transform.position -= currentPosition.dirToGroundPoint * Time.deltaTime;
        }
    }

    public void AimJump()
    {
        CameraController.mainCamController.frogCamOverride = true;
        rb.velocity = Vector2.zero;
        aiming = true;
        arc.render = true;
        arc.velocity = v = Mathf.Lerp(velocityMin, velocityMax, tv);
        arc.angle = a = Mathf.Lerp(angleMin, angleMax, ta);

        float inputValueX = flipped ? -Input.GetAxis("Horizontal") : Input.GetAxis("Horizontal");

        ta += Input.GetAxis("Vertical") * scrollSpeed * Time.deltaTime;
        tv += inputValueX * scrollSpeed * Time.deltaTime;

        if (tv < 0.01f && Input.GetAxis("Horizontal") < 0 && !flipped)
        {
            flipped = true;
            transform.localScale = new Vector3(0.5f, 0.5f);
        }
        else if (tv < 0.01f && Input.GetAxis("Horizontal") > 0 && flipped)
        {
            flipped = false;
            transform.localScale = new Vector3(-0.5f, 0.5f);
        }

        if (Input.GetKey(KeyCode.RightArrow))
        {
            tv += scrollSpeed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            tv -= scrollSpeed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.UpArrow))
        {
            ta += scrollSpeed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            ta -= scrollSpeed * Time.deltaTime;
        }

        tv = Mathf.Clamp01(tv);
        ta = Mathf.Clamp01(ta);

        aimDir = (Quaternion.AngleAxis(arc.flipped ? -a : a, Vector3.forward) * (arc.flipped ? Vector3.left : Vector3.right)).normalized;
        jumpDistance = Vector3.Distance(transform.position, arc.hitPoint);
    }

    public event Action onLanded;

    public void CharacterLandedTrigger()
    {
        if (!isGrounded)
        {
            if (IsGrounded())
            {
                OnCharacterLanded();
            }
            else
            {
                rb.gravityScale = 1;
            }
        }
    }
    public void CharacterLanded()
    {
        isGrounded = true;
        canJump = true;
        //jumpStarted = false;
        rb.gravityScale = 0;
        rb.inertia = 0;
        rb.velocity = Vector2.zero;
        //startY = 0;
        //jumpHeight = 0;
    }

    public void OnCharacterLanded()
    {
        onLanded?.Invoke();
    }

    public bool IsGrounded()
    {
        bool output = false;
        RaycastHit2D hit2 =
        Physics2D.CapsuleCast(frogMidPoint, col.size, CapsuleDirection2D.Horizontal, 0, -transform.up, Mathf.Infinity, groundMask);

        output = hit2.distance < minHeight / 2;
        return output;
    }

    public Vector3 ClosestGroundPoint()
    {
        Vector3 output = Vector3.zero;

        RaycastHit2D hit1 = Physics2D.CircleCast(frogMidPoint + transform.up, col.size.x/3, -transform.up, Mathf.Infinity, groundMask);
        if (hit1.collider)
        {
            output = hit1.point;
        }

        return output;
    }

    public void WalkSoundEffect()
    {

    }

    public void OnDrawGizmos()
    {
        Gizmos.DrawWireSphere(frogMidPoint + transform.up, col.size.x/3);
    }

    public Vector3 RotationFromDir(Vector3 dir)
    {
        float angle = Mathf.Atan2(dir.y, dir.x) * Mathf.Rad2Deg;
        return new Vector3(0,0,angle);
    }
}

public class FrogPositionInfo
{
    public Vector3 closestGroundPoint;
    public Vector3 dirToGroundPoint;
    public float distToGroundPoint;

    public FrogPositionInfo (Vector3 _cgp, float _disttgp, Vector3 _dirtgp)
    {
        closestGroundPoint = _cgp;
        dirToGroundPoint = _dirtgp;
        distToGroundPoint = _disttgp;
    }
}
