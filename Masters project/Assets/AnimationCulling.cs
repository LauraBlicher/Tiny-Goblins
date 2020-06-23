using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.U2D.Animation;

public class AnimationCulling : MonoBehaviour
{
    public Camera cam;
    public SpriteSkin[] skins;
    public int count;
    public Vector2 screenPos;
    public bool isVisible;

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
        output = screenPos.x < 1.1f && screenPos.y > -0.1f && screenPos.y < 1.1f && screenPos.x > -0.1f;
        return output;
    }
}
