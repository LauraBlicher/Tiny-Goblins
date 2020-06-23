using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrayToNormals : MonoBehaviour
{
    public RenderTexture rt;
    public Texture2D outputTexture;
    public Material mat;
    // Start is called before the first frame update
    void Start()
    {
        outputTexture.height = rt.height;
        outputTexture.width = rt.width;
       //rend = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void LateUpdate()
    {
        outputTexture = GenerateNormalMap(rt);
        outputTexture.Apply();

        mat.SetTexture("_NormalSomething", outputTexture);
    }

    public Texture2D GenerateNormalMap(RenderTexture bumpSource)
    {
        RenderTexture.active = bumpSource;
        Texture2D tex = new Texture2D(bumpSource.width, bumpSource.height);
        tex.ReadPixels(new Rect(0, 0, bumpSource.width, bumpSource.height), 0, 0);
        tex.Apply();

        for (int y = 0; y < tex.height; y++)
        {
            for (int x = 0; x < tex.width; x++)
            {
                
                float xLeft = -tex.GetPixel(x - 1, y).grayscale;
                float xRight = -tex.GetPixel(x + 1, y).grayscale;
                float yUp = -tex.GetPixel(x, y - 1).grayscale;
                float yDown = -tex.GetPixel(x, y + 1).grayscale;
                float xDelta = ((xLeft - xRight) + 1) * 0.5f;
                float yDelta = ((yUp - yDown) + 1) * 0.5f;

                tex.SetPixel(x, y, new Color(xDelta, yDelta, 1.0f, 1.0f));

            }
        }
        RenderTexture.active = null;
        return tex;
    }
}
