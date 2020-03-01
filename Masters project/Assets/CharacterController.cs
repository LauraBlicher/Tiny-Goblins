using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public class CharacterController : MonoBehaviour
{
    private Rigidbody2D rb;
    private Vector2 oldPos, newPos;
    private Vector2 velocity;
    private bool isGrounded;
    private bool canMove;
    private float characterHeight;
    private RaycastHit2D hit;
    public float jumpHeight = 0;
    private bool startYSet = false;
    private float startY = 0;
    private bool canJump = true;

    [Header("Dependencies")]
    public LayerMask groundMask;
    public SpriteRenderer sr;
    private BoxCollider2D col;
    public Animator anim;

    [Header("Character Stats")]
    public float movementSpeed = 1f;
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
        col = GetComponent<BoxCollider2D>();
        characterHeight = sr.size.y;        
    }

    // Update is called once per frame
    void Update()
    {
        // Maths
        newPos = transform.position;
        velocity = newPos - oldPos;
        oldPos = newPos;
        //hit = Physics2D.BoxCast(col.bounds.center, col.bounds.size, 0f, Vector2.down, 0.01f, groundMask);
        //isGrounded = hit.collider;
        Debug.DrawRay(transform.position, Vector3.down * (characterHeight / 2 + 0.1f));
        canMove = hasAirControl || (!hasAirControl && isGrounded);

        CharacterLandedTrigger(false);
        if (velocity.y == 0)
        {
            CharacterLandedTrigger(true);
        }
        // Receive Inputs
        if (canMove)
            transform.position += new Vector3(Input.GetAxis("Horizontal") * (isGrounded ? movementSpeed : movementSpeed) * Time.deltaTime, 0, 0);

        if (Input.GetButton("Jump"))
        {
            if (canJump)
                Jump();
        }
        if (Input.GetButtonUp("Jump"))
        {
            canJump = false;
        }
        if (isGrounded && !canJump)
            canJump = true;

        // Animations
        anim.SetFloat("speed", Mathf.Abs(velocity.x));
        if (!isGrounded && velocity.y < 0)
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
            RaycastHit2D hit2 = Physics2D.BoxCast(col.bounds.center, col.bounds.size, 0f, Vector2.down, 0.011f, groundMask);
            if (hit2.collider)
            {
                OnCharacterLanded();
            }
        }
    }

    public void CharacterLanded()
    {
        isGrounded = true;
        canJump = true;
        startYSet = false;
        startY = 0;
        jumpHeight = 0;
        anim.SetTrigger("landed");
        anim.ResetTrigger("jump");
    }

    public void Jump()
    {        
        if (!startYSet)
        {
            anim.ResetTrigger("falling");
            anim.ResetTrigger("landed");
            anim.SetTrigger("jump");
            startY = transform.position.y;
            jumpHeight = 0;
            startYSet = true;
            isGrounded = false;
        }
        //Vector2 jumpDir = (Vector2.up + velocity.normalized).normalized;
        if (jumpHeight <= startY + jumpHeightMax && velocity.y >= 0)
        {
            jumpHeight = transform.position.y;
            rb.velocity = Vector2.up * jumpForceMin;
        }
    }
}
