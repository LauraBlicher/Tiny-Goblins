using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class ThoughtBubble : MonoBehaviour
{
    private Renderer[] renderers;
    public Renderer primeBubble;
    public List<Texture> images = new List<Texture>();
    public float fadeSpeedSeconds = 1f;
    public float timeBetweenImageChange = 1f;
    private float t = 0;
    private bool thoughtsStarted = false;
    public bool repeat = false;

    public event Action onEnd;

    void Awake()
    {
       // foreach (Transform child in transform)
       // {
       //     renderers.Add(child.GetComponent<Renderer>());
       // }
        renderers = GetComponentsInChildren<Renderer>();
    }

    void Update()
    {
        if (!thoughtsStarted)
        {
            foreach (Renderer r in renderers)
            {
                r.material.SetFloat("_FadeIn", Mathf.Lerp(0, 2, t));
            }

            t += Time.deltaTime / fadeSpeedSeconds;
            t = Mathf.Clamp01(t);
        }

        if (t == 1 && !thoughtsStarted)
        {
            StartCoroutine(Thoughts());
        }
    }

    IEnumerator Thoughts()
    {
        thoughtsStarted = true;

        while (true)
        {
            for (int i = 0; i < images.Count; i++)
            {
                primeBubble.material.SetTexture("_Image", images[i]);
                yield return new WaitForSeconds(timeBetweenImageChange);
            }

            if (!repeat)
                break;
        }

        while (t > 0)
        {
            foreach (Renderer r in renderers)
            {
                r.material.SetFloat("_FadeIn", Mathf.Lerp(0, 2, t));
            }
            t -= Time.deltaTime / fadeSpeedSeconds;
            t = Mathf.Clamp01(t);
            yield return null;
        }
        onEnd.Invoke();
        Destroy(gameObject);
    }
}
