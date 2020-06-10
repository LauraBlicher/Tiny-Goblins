using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "New Thought", menuName = "Thought")]
public class Thought : ScriptableObject
{
    public List<Texture> images = new List<Texture>();
    public float timeBetweenImages = 1f;
    public bool repeat = false;
    public int index = 0;
}
