using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public class CharacterController : MonoBehaviour
{
    private Rigidbody2D rb;
    private Vector2 oldPos, newPos;
    public enum CharacterType { Goblin, Frog, Beetle, Bird }
    public CharacterController frog;

    public Vector2 velocity;
    private Vector2 vel1, vel2;
    public bool isGrounded;
    public bool canMove = true;
    private float characterHeight;
    private RaycastHit2D hit;
    public float jumpHeight = 0;
    private bool startYSet = false;
    private float startY = 0;
    private bool canJump = true;
    public float groundAngle = 0;
    private Vector3 newRight;
    private Vector3 walkDir;
    public bool overrideControl = false;
    public bool isMounted = false;
    private static bool interactionSeparator = false;
    public float movespeedT;
    public bool sliding = false;
    private float right;
    public bool sprinting = false;
    private float jumpT = 0;
    private bool hasNotReleased = false;

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

    public void Awake()
    {
        onLanded += CharacterLanded;
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
        // Maths
        newPos = transform.position;
        vel1 = newPos - oldPos;
        velocity = (vel1 + vel2) / 2;
        vel2 = vel1;
        oldPos = newPos;
        right = Mathf.Round(Input.GetAxis("Horizontal")) >= 0 ? 1 : -1;
        groundAngle = CalculateSlopeAngle() * right;
        movespeedT = Mathf.InverseLerp(-angleMax, angleMax, groundAngle);
        sprinting = Input.GetKey(KeyCode.LeftShift);
        movementSpeed = Mathf.Lerp(msMax, msMin, movespeedT) * (sprinting ? 1.5f : 1);
        newRight = Quaternion.AngleAxis(groundAngle * right, Vector3.forward) * Vector3.right;
        walkDir = newRight * (Input.GetAxis("Horizontal") * movementSpeed * Time.deltaTime);
        Debug.DrawRay(transform.position, walkDir * 10, Color.red);
        //hit = Physics2D.BoxCast(col.bounds.center, col.bounds.size, 0f, Vector2.down, 0.01f, groundMask);
        //isGrounded = hit.collider;
        Debug.DrawRay(transform.position, Vector3.down * (characterHeight / 2 + 0.1f));
        if (Mathf.Abs(groundAngle) > angleMax || Mathf.Abs(groundAngle) < -angleMax)
        {
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
        //if (velocity.y == 0)
        //{
        //    CharacterLandedTrigger(true);
        //}

        // Receive Inputs
        if (canMove && isActive && !overrideControl)
        {
            transform.position += walkDir; // new Vector3(Input.GetAxis("Horizontal") * (isGrounded ? movementSpeed : movementSpeed) * Time.deltaTime, 0, 0);

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

            if (Input.GetButtonDown("Interact"))
            {
                if (!interactionSeparator)
                {
                    if (type != CharacterType.Goblin)
                    {
                        CharacterManager.instance.Unmount();
                        interactionSeparator = true;
                    }
                    else
                    {
                        CharacterManager.instance.Mount(frog);
                        interactionSeparator = true;
                    }
                }
                else
                {
                    interactionSeparator = false;
                }
            }
            if (Input.GetButtonUp("Interact"))
            {
                interactionSeparator = false;
            }
        }
        // Animations
        if (anim)
        {
            if (canMove && isGrounded && velocity.y < 0)
            {
                anim.SetTrigger("landed");
                anim.SetFloat("speed", Mathf.Abs(Input.GetAxis("Horizontal")));
            }
            else if (!canMove)
            {
                anim.SetTrigger("falling");
            }
        }
        if (!isGrounded && velocity.y < 0 && anim)
            anim.SetTrigger("falling");
        if (velocity.x < 0)
        {
            sr.flipX = false;
        }
        else if (velocity.x > 0)
            sr.flipX = true;
        else
            sr.flipX = sr.flipX;
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
        startYSet = false;
        rb.gravityScale = 0;
        startY = 0;
        jumpHeight = 0;
        if (anim)
        {
            anim.SetTrigger("landed");
            anim.ResetTrigger("jump");
        }
    }

    public void Slide()
    {
        col.sharedMaterial = slide;
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
        if (!startYSet)
        {
            jumpT = 0;
            if (anim)
            {
                anim.ResetTrigger("falling");
                anim.ResetTrigger("landed");
                anim.SetTrigger("jump");
            }
            startY = transform.position.y;
            jumpHeight = transform.position.y;
            startYSet = true;
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
            //print(angle);
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
