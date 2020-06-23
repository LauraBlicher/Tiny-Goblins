using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThoughtCreator : MonoBehaviour
{
    public GameObject thoughtPrefab;
    private GameObject primaryBubble, firstBubble;
    private GameObject newBubble;

    public DistanceJoint2D joint;

    public Thought currentThought;
    public List<Thought> thoughts = new List<Thought>();

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            CreateThoughtBubble(0);
        }
    }

    private void CreateThoughtBubble(int index)
    {
        Destroy(newBubble);

        newBubble = Instantiate(thoughtPrefab, transform.position, Quaternion.identity);

        primaryBubble = newBubble.transform.GetChild(0).gameObject;
        firstBubble = newBubble.transform.GetChild(3).gameObject;

        joint.connectedBody = firstBubble.GetComponent<Rigidbody2D>();
        joint.distance = 0.5f;
        joint.enabled = true;

        currentThought = thoughts[index];

        ThoughtBubble bubble = newBubble.GetComponent<ThoughtBubble>();

        bubble.timeBetweenImageChange = currentThought.timeBetweenImages;
        bubble.repeat = currentThought.repeat;
        bubble.images = currentThought.images;
    }
}
