using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FrogScript : MonoBehaviour
{
    public ArcRenderer arc;
    public Rigidbody2D rb;
    public SpriteRenderer sr;
    public CharacterController cc;
    public float velocityMin, velocityMax;
    public float angleMin, angleMax;
    public float scrollSpeed = 1f;
    float ta = 0, tv = 0;
    float v, a;
    bool aiming = false;
    Vector3 aimDir;

    // Start is called before the first frame update
    void Start()
    {
        cc = GetComponent<CharacterController>();
        a = angleMin;
        v = velocityMin;
        arc.velocity = v;
        arc.angle = a;
    }

    // Update is called once per frame
    void Update()
    {
        if (cc.isActive)
        {
            if (Input.GetKey(KeyCode.Space))
            {
                AimJump();
            }
            else
            {
                if (aiming)
                {
                    arc.render = false;
                    rb.velocity = Vector3.zero;
                    rb.AddForce(aimDir * v, ForceMode2D.Impulse);
                    aiming = false;
                    cc.overrideControl = false;
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
        if (cc.isActive)
        {
            cc.overrideControl = true;
        }
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
    }
}
