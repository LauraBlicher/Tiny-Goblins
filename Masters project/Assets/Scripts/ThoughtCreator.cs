using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class ThoughtCreator : MonoBehaviour
{
    public GameObject thoughtPrefab;
    public GameObject speechPrefab;
    private GameObject primaryBubble, firstBubble;
    private GameObject newBubble;
    public Interaction currentNPC;

    public Thought question;

    public DistanceJoint2D joint;

    public Thought currentThought;
    public List<Thought> thoughts = new List<Thought>();

    private bool maintainTail = false;
    public Transform tail;

    public float speed = 2;

    public int thoughtIndex = 0;

    void Update()
    {
        if (transform.parent.CompareTag("Goblin") && currentNPC)
        {
            if (Input.GetKeyDown(KeyCode.E))
            {
                if (currentNPC.canBeAsked)
                {
                    CreateSpeechBubble(question);
                }
                else
                {
                    Thought npcThought = currentNPC.GetComponent<ThoughtCreator>().thoughts[0];
                    CreateThoughtBubble(npcThought);
                }
                //CreateThoughtBubble(thoughtIndex);
                //CreateSpeechBubble(thoughtIndex);
            }
        }

        if (maintainTail && tail)
        {
            tail.position = transform.position;
        }
        
    }

    public void Speak(int index)
    {
        CreateSpeechBubble(index);
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

        Vector2 randomDir = Random.insideUnitCircle * speed;
        randomDir = new Vector2(randomDir.x, Mathf.Abs(randomDir.y));
        primaryBubble.GetComponent<Rigidbody2D>().AddForce(randomDir, ForceMode2D.Impulse);

        currentThought = thoughts[index];

        ThoughtBubble bubble = newBubble.GetComponent<ThoughtBubble>();

        bubble.timeBetweenImageChange = currentThought.timeBetweenImages;
        bubble.repeat = currentThought.repeat;
        bubble.images = currentThought.images;

        if (newBubble.GetComponent<SortingGroup>())
            newBubble.GetComponent<SortingGroup>().sortingLayerName = transform.parent.GetComponent<SortingGroup>().sortingLayerName;
    }
    private void CreateThoughtBubble(Thought thought)
    {
        Destroy(newBubble);

        newBubble = Instantiate(thoughtPrefab, transform.position, Quaternion.identity);

        primaryBubble = newBubble.transform.GetChild(0).gameObject;
        firstBubble = newBubble.transform.GetChild(3).gameObject;

        joint.connectedBody = firstBubble.GetComponent<Rigidbody2D>();
        joint.distance = 0.5f;
        joint.enabled = true;

        Vector2 randomDir = Random.insideUnitCircle * speed;
        randomDir = new Vector2(randomDir.x, Mathf.Abs(randomDir.y));
        primaryBubble.GetComponent<Rigidbody2D>().AddForce(randomDir, ForceMode2D.Impulse);


        ThoughtBubble bubble = newBubble.GetComponent<ThoughtBubble>();

        bubble.timeBetweenImageChange = thought.timeBetweenImages;
        bubble.repeat = thought.repeat;
        bubble.images = thought.images;

        if (transform.parent.GetComponent<SortingGroup>())
            newBubble.GetComponent<SortingGroup>().sortingLayerName = transform.parent.GetComponent<SortingGroup>().sortingLayerName;
    }

    private void CreateSpeechBubble(int index)
    {
        Destroy(newBubble);

        newBubble = Instantiate(speechPrefab, transform.position, Quaternion.identity);

        joint.connectedBody = newBubble.GetComponent<Rigidbody2D>();
        joint.distance = 3f;
        joint.enabled = true;

        tail = newBubble.transform.GetChild(0).GetChild(1).GetChild(0);
        maintainTail = true;

        Vector2 randomDir = Random.insideUnitCircle * speed;
        randomDir = new Vector2(randomDir.x, Mathf.Abs(randomDir.y));
        newBubble.GetComponent<Rigidbody2D>().AddForce(randomDir, ForceMode2D.Impulse);

        ThoughtBubble bubble = newBubble.GetComponent<ThoughtBubble>();

        currentThought = thoughts[index];

        bubble.timeBetweenImageChange = currentThought.timeBetweenImages;
        bubble.repeat = currentThought.repeat;
        bubble.images = currentThought.images;
        if(transform.parent.GetComponent<SortingGroup>())
            newBubble.GetComponent<SortingGroup>().sortingLayerName = transform.parent.GetComponent<SortingGroup>().sortingLayerName;
    }

    private void CreateSpeechBubble(Thought thought)
    {
        Destroy(newBubble);

        newBubble = Instantiate(speechPrefab, transform.position, Quaternion.identity);

        joint.connectedBody = newBubble.GetComponent<Rigidbody2D>();
        joint.distance = 3f;
        joint.enabled = true;

        tail = newBubble.transform.GetChild(0).GetChild(1).GetChild(0);
        maintainTail = true;

        Vector2 randomDir = Random.insideUnitCircle * speed;
        randomDir = new Vector2(randomDir.x, Mathf.Abs(randomDir.y));
        newBubble.GetComponent<Rigidbody2D>().AddForce(randomDir, ForceMode2D.Impulse);

        ThoughtBubble bubble = newBubble.GetComponent<ThoughtBubble>();

        bubble.timeBetweenImageChange = thought.timeBetweenImages;
        bubble.repeat = thought.repeat;
        bubble.images = thought.images;
        if (transform.parent.GetComponent<SortingGroup>())
            newBubble.GetComponent<SortingGroup>().sortingLayerName = transform.parent.GetComponent<SortingGroup>().sortingLayerName;

        if (thought == question)
            bubble.onEnd += OnQuestionAsked;
    }

    private void OnQuestionAsked()
    {
        currentNPC.Interact();
    }
}
