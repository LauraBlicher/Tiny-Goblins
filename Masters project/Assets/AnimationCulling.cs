using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.U2D.Animation;

public class AnimationCulling : MonoBehaviour
{
    public bool bigObject = false;
    public Camera cam;
    public SpriteSkin[] skins;
    public int count;
    public Vector2 screenPos;
    public bool isVisible;
    [Range(0.1f,1)]
    public float outOfBoundsSize = 0.5f;

    void Awake()
    {
        cam = Camera.main;
        skins = transform.GetComponentsInChildren<SpriteSkin>();
        count = skins.Length;
    }


    void LateUpdate()
    {
        isVisible = IsVisible();
        foreach(SpriteSkin s in skins)
        {
            s.enabled = IsVisible();
        }
    }

    bool IsVisible()
    {
        bool output = false;
        screenPos = cam.WorldToViewportPoint(transform.position);
        output = screenPos.x < (bigObject ? 1+outOfBoundsSize : 1.1f)
            && screenPos.y > (bigObject ? -outOfBoundsSize : -0.1f)
            && screenPos.y < (bigObject ? 1+outOfBoundsSize : 1.1f) 
            && screenPos.x > (bigObject ? -outOfBoundsSize : -0.1f);
        return output;
    }
}
