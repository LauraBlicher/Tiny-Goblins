using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DissovePoint : MonoBehaviour
{
    public Vector4 GoblinPos;
    public Transform goblin;
    private PolygonCollider2D col;
    public Material mat;
    public bool isActive;
    public bool isInside;

    private float t = 0;

    void Start()
    {
        col = GetComponent<PolygonCollider2D>();
        mat = GetComponent<Renderer>().material;
    }
 
    void Update()
    {
        if (!goblin)
        {
            goblin = CharacterController.theGoblin.transform;
        }
        GoblinPos = goblin.position;
        mat.SetVector("_StartPosition", GoblinPos);
        //float r = mat.GetFloat("_Radius");
        mat.SetFloat("_Radius", Mathf.Lerp(!isInside ? 7.5f : 0, isInside ? 7.5f : 0, t));
        t += Time.deltaTime;
        t = Mathf.Clamp01(t);
    }

    void OnTriggerStay2D (Collider2D other)
    {
        if (other.transform == goblin)
        {
            if (isActive)
            {
                if (!isInside)
                {
                    isInside = true;
                    t = 0;
                }
            }
        }
    }

    void OnTriggerExit2D (Collider2D other)
    {
        if (other.transform == goblin)
        {
            if (isActive)
            {
                isInside = false;
                t = 0;
            }
        }
    }
}
