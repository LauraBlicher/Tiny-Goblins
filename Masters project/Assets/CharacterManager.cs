using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterManager : MonoBehaviour
{
    public static CharacterManager instance;
    public CharacterController currentCharacter;
    public static List<CharacterController> controllableCharacters = new List<CharacterController>();
    public Camera mainCam;
    private CameraController camController;

    public void Awake()
    {
        instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        camController = mainCam.GetComponent<CameraController>();
        controllableCharacters.Add(currentCharacter);
        //camController.characterToFollow = currentCharacter.transform;
    }

    // Update is called once per frame
    void Update()
    {
        print("Following " + currentCharacter.name);
        //camController.characterToFollow = currentCharacter.transform;
    }

    public void Mount(CharacterController character)
    {
        print(character.ToString());
        if (!controllableCharacters.Contains(character))
        {
            controllableCharacters.Add(character);
        }
        currentCharacter = character;
        currentCharacter.isMounted = true;
        currentCharacter.isActive = true;
        DeactivateNonActiveCharacters();
    }

    public void Unmount()
    {
        print("unmounted");
        currentCharacter.isMounted = false;
        currentCharacter = controllableCharacters[0];
        currentCharacter.isActive = true;
        DeactivateNonActiveCharacters();
    }

    public void DeactivateNonActiveCharacters()
    {
        for (int i = 0; i < controllableCharacters.Count; i++)
        {
            if (controllableCharacters[i] != currentCharacter)
            {
                controllableCharacters[i].isActive = false;
            }
        }
    }
}
