using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DissovePoint : MonoBehaviour
{
    public Vector4 GoblinPos;
    public Transform goblin;
 
    void Update()
    {
        if (!goblin)
        {
            goblin = CharacterController.theGoblin.transform;
        }
        GoblinPos = goblin.position;
        GetComponent<Renderer>().material.SetVector("_StartPosition", GoblinPos);
    }

}
