using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    public bool allowLoad = false;
    void Start()
    {
        StartCoroutine(Load());
    }

    public void AllowLoad()
    {
        allowLoad = true;
    }

    IEnumerator Load()
    {
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
