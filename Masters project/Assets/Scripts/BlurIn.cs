using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BlurIn : MonoBehaviour
{
    float t = 0;
    public float fadeSpeed = 3;
    public float startValue = 1;
    public Image img;

    // Start is called before the first frame update
    void Start()
    {
        img = GetComponent<Image>();
        img.material.SetFloat("_Size", startValue);
    }

    // Update is called once per frame
    void Update()
    {
        img.material.SetFloat("_Size", Mathf.Lerp(startValue, 0, t));
        t += Time.deltaTime / fadeSpeed;
        t = Mathf.Clamp01(t);
    }
}
