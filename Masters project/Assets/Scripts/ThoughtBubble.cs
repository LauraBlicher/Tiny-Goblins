using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThoughtBubble : MonoBehaviour
{
    private List<Renderer> renderers = new List<Renderer>();
    public Renderer primeBubble;
    public List<Texture> images = new List<Texture>();
    public float fadeSpeedSeconds = 1f;
    public float timeBetweenImageChange = 1f;
    private float t = 0;
    private bool thoughtsStarted = false;
    public bool repeat = false;

    void Awake()
    {
        foreach (Transform child in transform)
        {
            renderers.Add(child.GetComponent<Renderer>());
        }
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

        Destroy(gameObject);
    }
}
