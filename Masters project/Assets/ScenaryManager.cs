using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScenaryManager : MonoBehaviour
{
    public static ScenaryManager instance;
    public Camera cam;
    public float transisitionSpeed = 1f;
    public Transform frontLayer, middleLayer, backLayer;
    [Tooltip("Compared to camera Z")] public float zWayFront = -1f, zFront = 1f, zMiddle = 21f, zBack = 41f;
    public Transform foliage1, foliage2, foliage3;
    [Tooltip("Compared to camera Z")] public float f0z = -1f, f1z = 11f, f2z = 31f, f3z = 51f;
    public float t = 0;
    public bool moveForward = false, moveBack = false;
    public List<PositionInfo> positions = new List<PositionInfo>();

    public enum Position { Wayfront, Front, Middle, Back }

    void Awake()
    {
        instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        positions.Add(new PositionInfo(frontLayer, Position.Front));
        positions.Add(new PositionInfo(middleLayer, Position.Middle));
        positions.Add(new PositionInfo(backLayer, Position.Back));
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.I))
        {
            moveForward = true;
        }
        if (Input.GetKey(KeyCode.K))
        {
            moveBack = true;
        }
        if (moveForward)
        {
            MoveForward();
        }
        if (moveBack)
        {
            MoveBack();
        }
    }

    public void MoveForward()
    {
        for (int i = 0; i < positions.Count; i++)
        {
            positions[i].MoveForward(t);
        }
        t += transisitionSpeed * Time.deltaTime;
        t = Mathf.Clamp01(t);
        if (t == 1)
        {
            moveForward = false;
            for (int i = 0; i < positions.Count; i++)
            {
                positions[i].SetNewPos(true);
            }
            t = 0;
        }
    }

    public void MoveBack()
    {
        for (int i = 0; i < positions.Count; i++)
        {
            positions[i].MoveBack(t);
        }
        t += transisitionSpeed * Time.deltaTime;
        t = Mathf.Clamp01(t);
        if (t == 1)
        {
            moveBack = false;
            for (int i = 0; i < positions.Count; i++)
            {
                positions[i].SetNewPos(false);
            }
            t = 0;
        }
    }
}

public class PositionInfo
{
    public Transform obj;
    public ScenaryManager.Position currentPos;
    public Vector3 currentPosV3, forward, back;

    public PositionInfo(Transform _obj, ScenaryManager.Position _pos)
    {
        obj = _obj;
        currentPos = _pos;
        currentPosV3 = obj.position;
        SetOtherPos();
    }

    public void SetOtherPos()
    {
        float camZ = ScenaryManager.instance.cam.transform.position.z;

        switch(currentPos)
        {
            case ScenaryManager.Position.Wayfront:
                forward = new Vector3(obj.position.x, obj.position.y, camZ + ScenaryManager.instance.zFront);
                back = new Vector3(obj.position.x, obj.position.y, camZ + ScenaryManager.instance.zWayFront);
                break;
            case ScenaryManager.Position.Front:
                forward = new Vector3(obj.position.x, obj.position.y, camZ + ScenaryManager.instance.zMiddle);
                back = new Vector3(obj.position.x, obj.position.y, camZ + ScenaryManager.instance.zWayFront);
                break;
            case ScenaryManager.Position.Middle:
                forward = new Vector3(obj.position.x, obj.position.y, camZ + ScenaryManager.instance.zBack);
                back = new Vector3(obj.position.x, obj.position.y, camZ + ScenaryManager.instance.zFront);
                break;
            case ScenaryManager.Position.Back:
                forward = new Vector3(obj.position.x, obj.position.y, camZ + ScenaryManager.instance.zBack);
                back = new Vector3(obj.position.x, obj.position.y, camZ + ScenaryManager.instance.zMiddle);
                break;
            default:
                break;
        }
    }

    public void SetNewPos(bool movedForward)
    {
        switch (currentPos)
        {
            case ScenaryManager.Position.Wayfront:
                currentPos = movedForward ? ScenaryManager.Position.Front : ScenaryManager.Position.Wayfront;
                break;
            case ScenaryManager.Position.Front:
                currentPos = movedForward ? ScenaryManager.Position.Middle : ScenaryManager.Position.Wayfront;
                break;
            case ScenaryManager.Position.Middle:
                currentPos = movedForward ? ScenaryManager.Position.Back : ScenaryManager.Position.Front;
                break;
            case ScenaryManager.Position.Back:
                currentPos = movedForward ? ScenaryManager.Position.Back : ScenaryManager.Position.Middle;
                break;
        }

        obj.GetComponent<EdgeCollider2D>().enabled = currentPos == ScenaryManager.Position.Middle;
        currentPosV3 = obj.position;
        SetOtherPos();
    }

    public void MoveForward(float t)
    {
        obj.position = Vector3.Lerp(currentPosV3, forward, t);
    }

    public void MoveBack(float t)
    {
        obj.position = Vector3.Lerp(currentPosV3, back, t);
    }
}
