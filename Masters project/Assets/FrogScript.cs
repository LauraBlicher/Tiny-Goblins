using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class FrogScript : MonoBehaviour
{
    public LayerMask groundMask;
    public Transform checkPoint1, checkPoint2, c1Holder, c2Holder;
    public ArcRenderer arc;
    public Rigidbody2D rb;
    public SpriteRenderer sr;
    public CapsuleCollider2D col;
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
    bool aiming = false;
    Vector3 aimDir;
    public float acceptableHeight = 1f;
    private float right;
    public float groundAngle;
    public float groundAngleNew;
    private float movementSpeed;
    private Vector3 newRight;
    private Vector3 walkDir;

    void Awake()
    {
        onLanded += CharacterLanded;
    }
    // Start is called before the first frame update
    void Start()
    {
        col = GetComponent<CapsuleCollider2D>();
        a = angleMin;
        v = velocityMin;
        arc.velocity = v;
        arc.angle = a;
    }

    // Update is called once per frame
    void Update()
    {
        CharacterLandedTrigger();
        checkPoint1.position = c1Holder.position + Vector3.right * 1.5f;
        checkPoint2.position = c2Holder.position + Vector3.left * 1.5f;
        if (isMounted)
        {
            movementInput = canMove ? Input.GetAxis("Horizontal") : 0;
            right = sr.flipX ? 1 : -1;
            groundAngle = CalculateSlopeAngle() * right;
            groundAngleNew = CalculateSlopeAngleNew() * -right;
            movementSpeed = isGrounded ? 2 : 0;
            newRight = Quaternion.AngleAxis(groundAngleNew * right, Vector3.forward) * Vector3.right;
            transform.rotation = Quaternion.Euler(0, 0, right * groundAngleNew);
            walkDir = (isGrounded ? newRight : Vector3.right * Mathf.Abs(movementInput)) * (movementInput * movementSpeed * Time.deltaTime);

            RaycastHit2D hit = Physics2D.CapsuleCast(transform.position, col.size, CapsuleDirection2D.Horizontal, 0, -transform.up, Mathf.Infinity, groundMask);
            if (hit.collider)
            {
                if (hit.distance > col.size.y + 0.2f)
                {
                    isGrounded = IsGrounded();
                }
                if (hit.distance <= acceptableHeight - 0.1f)
                {
                    transform.position += transform.up * Time.deltaTime;
                }
            }

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
                        sr.flipX = true;
                    else if (h > 0)
                        sr.flipX = false;
                }
            }
            arc.flipped = sr.flipX;
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

        float inputValueX = sr.flipX ? -Input.GetAxis("Horizontal") : Input.GetAxis("Horizontal");

        ta += Input.GetAxis("Vertical") * scrollSpeed * Time.deltaTime;
        tv += inputValueX * scrollSpeed * Time.deltaTime;

        if (tv < 0.01f && Input.GetAxis("Horizontal") < 0 && !sr.flipX)
        {
            sr.flipX = true;
        }
        else if (tv < 0.01f && Input.GetAxis("Horizontal") > 0 && sr.flipX)
            sr.flipX = false;

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

        Vector3 dir = Quaternion.AngleAxis(CalculateSlopeAngle(), Vector3.forward) * Vector3.down;
        RaycastHit2D hit2 =
        Physics2D.CapsuleCast(transform.position, col.size, CapsuleDirection2D.Horizontal, 0, -transform.up, 1.11f, groundMask);

        output = hit2.collider;

        return output;
    }

    public float CalculateSlopeAngleNew()
    {
        RaycastHit2D hit1, hit2;
        float a, b, c, d, e, c1, c2, c3;

        hit1 = Physics2D.Raycast(checkPoint1.position, Vector3.down, Mathf.Infinity, groundMask);
        hit2 = Physics2D.Raycast(checkPoint2.position, Vector3.down, Mathf.Infinity, groundMask);

        Debug.DrawRay(checkPoint1.position, Vector3.down * hit1.distance, Color.cyan);
        Debug.DrawRay(checkPoint2.position, Vector3.down * hit2.distance, Color.cyan);

        if (hit1.collider && hit2.collider)
        {
            d = hit1.distance;
            b = hit2.distance;
            a = Vector2.Distance(checkPoint1.position, checkPoint2.position);
            c = Vector2.Distance(hit1.point, hit2.point);
            e = Vector2.Distance(hit1.point, checkPoint2.position);
            c1 = Mathf.Rad2Deg * Mathf.Acos((d * d + e * e - a * a) / (2 * d * e));
            print(c1);
            c2 = Mathf.Rad2Deg * Mathf.Acos((e * e + c * c - b * b) / (2 * e * c));
            print(c2);
            c3 = Mathf.Round(90 - c1 - c2);
        }
        else
        {
            c3 = -100;
        }
        return c3;
    }

    public float CalculateSlopeAngle()
    {
        RaycastHit2D hit1, hit2;
        Vector2 newangle = Vector2.down;
        Vector2 slopeAngle = Vector2.zero;
        float sideA, sideB, sideC;
        float angle = 0;
        newangle = SlopeIsLeft() ? Quaternion.AngleAxis(-30, Vector3.forward) * Vector2.down : Quaternion.AngleAxis(30, Vector3.forward) * Vector2.down;
        hit1 = Physics2D.Raycast(checkPoint1.position, Vector2.down, Mathf.Infinity, groundMask);
        hit2 = Physics2D.Raycast(checkPoint1.position, newangle, Mathf.Infinity, groundMask);
        //Debug.DrawRay(checkPoint1.position, Vector2.down * 10, Color.red);
        //Debug.DrawRay(checkPoint1.position, newangle * 10, Color.red);
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
        hit1 = Physics2D.Raycast(checkPoint1.position, angleLeft, Mathf.Infinity, groundMask);
        hit2 = Physics2D.Raycast(checkPoint2.position, angleRight, Mathf.Infinity, groundMask);
        //Debug.DrawRay(checkPoint1.position, angleLeft * 10, Color.cyan);
        //Debug.DrawRay(checkPoint2.position, angleRight * 10, Color.cyan);

        output = hit1.distance < hit2.distance;
        return output;
    }
}
