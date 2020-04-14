using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

[RequireComponent(typeof(Animator))]
public class CharacterController : MonoBehaviour
{
    private Rigidbody2D rb;
    private Vector2 oldPos, newPos;
    public enum CharacterType { Goblin, Frog, Beetle, Bird }
    public CharacterController frog;

    public static CharacterController theGoblin;

    public Vector2 velocity;
    private Vector2 vel1, vel2;
    public bool isGrounded;
    public bool canMove = true;
    private float characterHeight;
    private RaycastHit2D hit;
    public float jumpHeight = 0;
    private bool jumpStarted = false;
    private float startY = 0;
    private bool canJump = true;
    public float groundAngle = 0;
    private Vector3 newRight;
    private Vector3 walkDir;
    
    
    private static bool interactionSeparator = false;
    public float movespeedT;
    public float airSpeedT = 0;
    public bool sliding = false;
    private float right;
    public bool sprinting = false;
    private float jumpT = 0;
    private bool hasNotReleased = false;
    public float movementInput;

    [Header("Dependencies")]
    public LayerMask groundMask;
    public SpriteRenderer sr;
    private Collider2D col;
    public Animator anim;
    public Transform feet;
    public PhysicsMaterial2D normal, slide;

    [Header("Character Stats")]
    public CharacterType type = CharacterType.Goblin;
    public bool isActive;
    public float movementSpeed = 1f;
    public float msMin, msMax;
    public float angleMax = 40f;
    public float slideStopAngle = 20f;
    public float jumpForceMin = 1f, jumpHeightMax = 3f;
    public bool hasAirControl = false;

    // Mounting
    [Header("Mounts")]
    public GameObject mount;
    public Transform saddle;
    public float detectionRadius;
    public bool mountNearby;
    public LayerMask mountMask;
    public bool isMounted = false;
    public bool overrideControl = false;
    public float distToMount;
    public float minMountDist;
    public bool canMount = false;

    // Animations
    public enum AnimationState { Idle, Run, Sprint, Jump, Fall, Slide, Mounted }
    [Header("Animations")]
    public AnimationState currentAnimationState = AnimationState.Idle;
    private bool enterState = false;
    private bool lastFlipState = false;

    public void Awake()
    {
        onLanded += CharacterLanded;
        if (!theGoblin && type == CharacterType.Goblin)
        {
            theGoblin = this;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        oldPos = transform.position;
        newPos = transform.position;
        rb = GetComponent<Rigidbody2D>();
        col = GetComponent<Collider2D>();
        characterHeight = sr.size.y;        
    }

    // Update is called once per frame
    void Update()
    {
        AnimationStateMachine();
        if (!mountNearby)
            CheckForMounts();
        else
        {
            distToMount = Vector2.Distance(transform.position, mount.transform.position);
            if (distToMount > detectionRadius + detectionRadius * 0.2f)
            {
                mount = null;
                mountNearby = false;
            }
            if (distToMount <= minMountDist)
            {
                canMount = true;
            }
            else
            {
                canMount = false;
            }
        }

        // Maths
        newPos = transform.position;
        vel1 = newPos - oldPos;
        velocity = (vel1 + vel2) / 2;
        vel2 = vel1;
        oldPos = newPos;
        movementInput = canMove ? Input.GetAxis("Horizontal") : 0;
        right = lastFlipState ? 1 : -1;
        groundAngle = CalculateSlopeAngle() * right;
        movespeedT = Mathf.InverseLerp(-angleMax, angleMax, groundAngle);
        sprinting = Input.GetKey(KeyCode.LeftShift);
        movementSpeed = isGrounded ?
            Mathf.Lerp(msMax, msMin, movespeedT) * (sprinting ? 1.5f : 1) :
            Mathf.Lerp(movementSpeed, 3, airSpeedT);
        if (!isGrounded)
        {
            airSpeedT += Time.deltaTime / 3;
            airSpeedT = Mathf.Clamp01(airSpeedT);
        }
        else
        {
            airSpeedT = 0;
        }
        newRight = Quaternion.AngleAxis(groundAngle * right, Vector3.forward) * Vector3.right;
        walkDir = (isGrounded ? newRight : Vector3.right * Mathf.Abs(movementInput)) * (movementInput * movementSpeed * Time.deltaTime);
        Debug.DrawRay(transform.position, walkDir * 10, Color.red);
        Debug.DrawRay(transform.position, Vector3.down * (characterHeight / 2 + 0.1f));
        if (velocity.magnitude <= 0.005f && velocity.magnitude >= -0.005f)
        {
            velocity = Vector2.zero;
        }

        // Slide
        if (Mathf.Abs(groundAngle) > angleMax || Mathf.Abs(groundAngle) < -angleMax)
        {
            if (IsGrounded())
                sliding = true;
        }
        
        if (sliding)
        {
            Slide();
        }

        CharacterLandedTrigger(false);
        if (!sliding)
        {
            CharacterLandedTrigger(true);
        }

        // Receive Inputs
        if (canMove && isActive && !overrideControl)
        {
            transform.position += walkDir;

            if (!hasNotReleased)
            {
                if (Input.GetButton("Jump"))
                {
                    if (canJump)
                    {
                        Jump();
                    }
                    else
                    {
                        hasNotReleased = true;
                    }
                }
            }
            if (Input.GetButtonUp("Jump"))
            {
                canJump = false;
                hasNotReleased = false;
            }
            if (isGrounded && !canJump)
                canJump = true;
        }
        if (canMount)
        {
            if (Input.GetButtonDown("Interact"))
            {
                MountAction();
            }
        }
        if (isMounted)
        {
            transform.position = saddle.position;
        }
    }

    public void AnimationStateMachine()
    {
        switch (currentAnimationState)
        {
            default:
                break;
            case AnimationState.Idle:
                if (!enterState)
                {
                    anim.SetTrigger("enterIdle");
                    enterState = true;
                }
                if (velocity.x != 0)
                {
                    enterState = false;
                    currentAnimationState = sprinting ? AnimationState.Sprint : AnimationState.Run;
                    break;
                }
                if (velocity.y < 0 && !IsGrounded())
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Fall;
                    break;
                }
                if (jumpStarted)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Jump;
                    break;
                }
                if (sliding)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Slide;
                    break;
                }
                if (isMounted)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Mounted;
                    break;
                }
                break;
            case AnimationState.Run:
                if (!enterState)
                {
                    anim.SetTrigger("enterRun");
                    enterState = true;
                }
                if (sprinting)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Sprint;
                    break;
                }
                if (velocity == Vector2.zero)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Idle;
                    break;
                }
                if (velocity.y < 0 && !IsGrounded())
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Fall;
                    break;
                }
                if (jumpStarted)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Jump;
                    break;
                }
                if (sliding)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Slide;
                    break;
                }
                if (isMounted)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Mounted;
                    break;
                }
                break;
            case AnimationState.Sprint:
                if (!enterState)
                {
                    anim.SetTrigger("enterSprint");
                    enterState = true;
                }
                if (!sprinting)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Run;
                    break;
                }
                if (velocity == Vector2.zero)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Idle;
                    break;
                }
                if (velocity.y < 0 && !IsGrounded())
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Fall;
                    break;
                }
                if (jumpStarted)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Jump;
                    break;
                }
                if (sliding)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Slide;
                    break;
                }
                if (isMounted)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Mounted;
                    break;
                }
                break;
            case AnimationState.Jump:
                if (!enterState)
                {
                    anim.SetTrigger("enterJump");
                    enterState = true;
                }
                if (!canJump)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Fall;
                    break;
                }
                if (sliding)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Slide;
                    break;
                }
                break;
            case AnimationState.Fall:
                if (!enterState)
                {
                    anim.SetTrigger("enterFall");
                    enterState = true;
                }
                if (isGrounded)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Idle;
                    break;
                }
                break;
            case AnimationState.Slide:
                if (!enterState)
                {
                    anim.SetTrigger("enterFall");
                    enterState = true;
                }
                if (!sliding)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Idle;
                }
                break;
            case AnimationState.Mounted:
                if (!enterState)
                {
                    anim.SetTrigger("enterIdle");
                    enterState = true;
                }
                rb.velocity = Vector2.zero;
                if (!isMounted)
                {
                    enterState = false;
                    currentAnimationState = AnimationState.Idle;
                }
                break;
        }

        // Sprite flip
        if (velocity.x != 0)
        {
            if (velocity.x < 0)
            {
                sr.flipX = false;
                lastFlipState = false;
            }
            else if (velocity.x > 0)
            {
                sr.flipX = true;
                lastFlipState = true;
            }
        }
        else
        {
            sr.flipX = lastFlipState;
        }
    }

    public void OnDrawGizmos()
    {
        Gizmos.DrawWireSphere(transform.position, detectionRadius);

    }

    public void CheckForMounts()
    {
        Collider2D[] cols = Physics2D.OverlapCircleAll(transform.position, detectionRadius, mountMask);
        if (cols.Length != 0)
        {
            mountNearby = true;
            mount = cols[0].gameObject;
        }
    }

    public void MountAction()
    {
        col.isTrigger = !col.isTrigger;
        overrideControl = !overrideControl;
        isMounted = !isMounted;
        saddle = mount.transform.GetChild(mount.transform.childCount - 1);
        
        switch (mount.tag)
        {
            default:
                break;
            case "Frog":
                mount.GetComponent<FrogScript>().canMove = !mount.GetComponent<FrogScript>().canMove;
                mount.GetComponent<FrogScript>().isMounted = !mount.GetComponent<FrogScript>().isMounted;
                break;
            case "Beetle":
                break;
        }
    }

    public event Action onLanded;

    public void OnCharacterLanded()
    {
        onLanded?.Invoke();
    }

    public void CharacterLandedTrigger(bool test)
    {
        if (!isGrounded || test)
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

    public bool IsGrounded()
    {
        bool output = false;

        Vector3 dir = Quaternion.AngleAxis(CalculateSlopeAngle(), Vector3.forward) * Vector3.down;
        RaycastHit2D hit2 = Physics2D.Raycast(feet.position, dir, .51f, groundMask);
        Debug.DrawRay(feet.position, dir*0.51f, Color.blue);

        output = hit2.collider;

        return output;
    }

    public void CharacterLanded()
    {
        isGrounded = true;
        canJump = true;
        jumpStarted = false;
        rb.velocity = Vector2.zero;
        rb.gravityScale = 0;
        startY = 0;
        jumpHeight = 0;
    }

    public void Slide()
    {
        col.sharedMaterial = slide;
        rb.isKinematic = false;
        rb.gravityScale = 1;
        canMove = false;
        if (Mathf.Abs(groundAngle) <= slideStopAngle)
        {
            col.sharedMaterial = normal;
            rb.gravityScale = 0;
            canMove = true;
            sliding = false;
        }

    }

    public void Jump()
    {        
        if (!jumpStarted)
        {
            jumpT = 0;
            startY = transform.position.y;
            jumpHeight = transform.position.y;
            jumpStarted = true;
            isGrounded = false;
            rb.gravityScale = 1;
        }
        jumpT += Time.deltaTime;
        float jf = Mathf.Lerp(jumpForceMin, 0, jumpT);

        jumpHeight = transform.position.y;
        rb.velocity = Vector2.up * jf;
        
        if (jumpT >= 1)
        {
            canJump = false;
        }
    }

    public float CalculateSlopeAngle()
    {
        RaycastHit2D hit1, hit2;
        Vector2 newangle = Vector2.down;
        Vector2 slopeAngle = Vector2.zero;
        float sideA, sideB, sideC;
        float angle = 0;
        newangle = SlopeIsLeft() ? Quaternion.AngleAxis(-30, Vector3.forward)*Vector2.down : Quaternion.AngleAxis(30, Vector3.forward) * Vector2.down;
        hit1 = Physics2D.Raycast(transform.position, Vector2.down, Mathf.Infinity, groundMask);
        hit2 = Physics2D.Raycast(transform.position, newangle, Mathf.Infinity, groundMask);
        Debug.DrawRay(transform.position, Vector2.down * 10, Color.red);
        Debug.DrawRay(transform.position, newangle * 10, Color.red);
        if (hit1.collider && hit2.collider)
        {
            sideA = hit1.distance;
            sideB = hit2.distance;
            sideC = Vector2.Distance(hit1.point, hit2.point);
            angle = 90f - (Mathf.Rad2Deg * Mathf.Acos((Mathf.Pow(sideA, 2) + Mathf.Pow(sideC, 2) - Mathf.Pow(sideB, 2)) / (2 * sideA * sideC)));

            angle = SlopeIsLeft() ? -angle : angle;
        }
        else
        {
            angle = -100;
        }
        return Mathf.Round(angle);
    }

    public bool SlopeIsLeft()
    {
        bool output;
        RaycastHit2D hit1, hit2;
        Vector3 angleLeft = Quaternion.AngleAxis(-30, Vector3.forward) * Vector3.down;
        Vector3 angleRight = Quaternion.AngleAxis(30, Vector3.forward) * Vector3.down;
        hit1 = Physics2D.Raycast(transform.position, angleLeft, Mathf.Infinity, groundMask);
        hit2 = Physics2D.Raycast(transform.position, angleRight, Mathf.Infinity, groundMask);
        Debug.DrawRay(transform.position, angleLeft * 10, Color.cyan);
        Debug.DrawRay(transform.position, angleRight * 10, Color.cyan);

        output = hit1.distance < hit2.distance;
        return output;
    }
}
