using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    public bool allowLoad = false;
    bool loading = false;
    AsyncOperation load;
    float t = 0;
    void Start()
    {
        
    }

    void Update()
    {
        if (t > 1)
        {
            if (!loading)
            {
                if (SceneManager.GetActiveScene() == SceneManager.GetSceneByBuildIndex(0))
                {
                    load = SceneManager.LoadSceneAsync(1);
                    load.allowSceneActivation = false;
                    loading = true;
                }
                //StartCoroutine(Load());
            }
            else
            {
                if (!load.isDone)
                {
                    if (allowLoad)
                        load.allowSceneActivation = true;
                }
            }
        }
        t += Time.deltaTime;
    }

    public void AllowLoad()
    {
        allowLoad = true;
    }

    IEnumerator Load()
    {
        loading = true;
        yield return null;
        AsyncOperation load = SceneManager.LoadSceneAsync(1);
        load.allowSceneActivation = false;

        while (!load.isDone)
        {
            yield return null;
            load.allowSceneActivation = allowLoad;
        }
    }
}
