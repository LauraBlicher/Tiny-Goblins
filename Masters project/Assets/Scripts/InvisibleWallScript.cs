using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class InvisibleWallScript : MonoBehaviour
{
    private BoxCollider2D col;
    public enum Direction { Left, Right }
    public Direction prohibitedDirection = Direction.Left;

    // Start is called before the first frame update
    void Start()
    {
        col = GetComponent<BoxCollider2D>();    
    }

    // Update is called once per frame
    void Update()
    {
        
    }       

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Goblin"))
        {
            switch (prohibitedDirection)
            {
                default: break;
                case Direction.Left:
                    other.GetComponent<CharacterController>().SendMessage("HitInvisibleWall", true);
                    break;
                case Direction.Right:
                    other.GetComponent<CharacterController>().SendMessage("HitInvisibleWall", false);
                    break;
            }
        }
    }

    private void OnTriggerExit2D (Collider2D other)
    {
        if (other.CompareTag("Goblin"))
        {
            switch (prohibitedDirection)
            {
                default: break;
                case Direction.Left:
                    other.GetComponent<CharacterController>().SendMessage("LeftInvisibleWall");
                    break;
                case Direction.Right:
                    other.GetComponent<CharacterController>().SendMessage("LeftInvisibleWall");
                    break;
            }
        }
    }
}
