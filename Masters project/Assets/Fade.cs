using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Fade : MonoBehaviour
{
    public bool fadeOut = true;
    public Image img;
    public bool startFade = false;
    public float duration = 2;
    float t = 0;
    public Color fullBlack, transparentBlack;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (startFade)
        {
            img.color = Color.Lerp(fadeOut ? transparentBlack : fullBlack, fadeOut ? fullBlack : transparentBlack, t);

            t += Time.deltaTime / duration;
        }
    }

    public void StartFade()
    {
        startFade = true;
    }
}
