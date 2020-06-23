using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public CharacterController goblin;
    private Rigidbody2D rb;
    public float forwardOffset = 1;
    public float lerpSpeed = 2;
    public static Camera mainCam;
    public static CameraController mainCamController;

    public enum GoblinMovement { MoveLeft, MoveRight, StandStill, POI }
    public GoblinMovement currentMovement = GoblinMovement.StandStill;
    public GoblinMovement lastMovement = GoblinMovement.StandStill;
    public Vector3 targetPos;
    public Vector3 lastTargetPos;
    public Vector3 lastPos;
    private bool enterState = false;
    private float moveT = 0;
    private float lastT = 0;

    public PointOfInterestHandler currentPOI;
    public static List<PointOfInterestHandler> pois = new List<PointOfInterestHandler>();
    public bool usePOI = false;
    public float standardSize;

    public bool frogCamOverride = false;
    public float sizePerDistance = 1f;

    public Vector3 goblinVelocity;
    Vector3 walkDirCur, walkDirPrev, walkDirAvg;

    void Awake()
    {
        mainCam = GetComponent<Camera>();
        mainCamController = this;
    }
    // Start is called before the first frame update
    void Start()
    {
        //rb = goblin.GetComponent<Rigidbody2D>();
    }

    public void FixedUpdate()
    {
        if (!goblin)
            goblin = CharacterController.theGoblin;
        goblinVelocity = goblin.velocity.normalized * (goblin.sprinting ? 1 : 0.75f);
    }

    public void MovementStateMachine()
    {
        float offset = goblin.sprinting ? forwardOffset + 1 : forwardOffset;
        walkDirPrev = walkDirCur;
        walkDirCur = goblin.walkDir.normalized * offset;
        walkDirAvg = (walkDirCur + walkDirPrev) / 2;
        switch (currentMovement)
        {
            case GoblinMovement.StandStill:
                if (!enterState)
                {
                    moveT = 0;
                    enterState = true;
                }

                targetPos = goblin.transform.position + Vector3.back * 21;

                if (goblin.currentAnimationState == CharacterController.AnimationState.Run || goblin.currentAnimationState == CharacterController.AnimationState.Sprint)
                {
                    enterState = false;
                    lastT = moveT;
                    lastMovement = GoblinMovement.StandStill;
                    if (goblinVelocity.x < 0)
                    {
                        currentMovement = GoblinMovement.MoveRight;
                    }
                    else
                    {
                        currentMovement = GoblinMovement.MoveLeft;
                    }                    
                }
                if (usePOI)
                {
                    enterState = false;
                    lastT = moveT;
                    lastMovement = GoblinMovement.StandStill;
                    currentMovement = GoblinMovement.POI;
                }
                break;
            case GoblinMovement.MoveLeft:
                if (!enterState)
                {
                    moveT = 0;
                    enterState = true;
                }
                
                targetPos = goblin.transform.position + walkDirAvg + (Vector3.back * 21);

                if (goblin.currentAnimationState == CharacterController.AnimationState.Idle || (goblin.currentAnimationState == CharacterController.AnimationState.Slide && !usePOI))
                {
                    enterState = false;
                    lastT = moveT;
                    lastMovement = GoblinMovement.MoveLeft;
                    currentMovement = GoblinMovement.StandStill;
                }
                if (goblinVelocity.x > 0)
                {
                    enterState = false;
                    lastT = moveT;
                    lastMovement = GoblinMovement.MoveLeft;
                    currentMovement = GoblinMovement.MoveRight;
                }
                if (usePOI)
                {
                    enterState = false;
                    lastT = moveT;
                    lastMovement = GoblinMovement.MoveLeft;
                    currentMovement = GoblinMovement.POI;
                }
                break;
            case GoblinMovement.MoveRight:
                if (!enterState)
                {
                    moveT = 0;
                    enterState = true;
                }

                targetPos = goblin.transform.position + walkDirAvg + (Vector3.back * 21);

                if (goblin.currentAnimationState == CharacterController.AnimationState.Idle || (goblin.currentAnimationState == CharacterController.AnimationState.Slide && !usePOI))
                {
                    enterState = false;
                    lastT = moveT;
                    lastMovement = GoblinMovement.MoveRight;
                    currentMovement = GoblinMovement.StandStill;
                }
                if (goblinVelocity.x < 0)
                {
                    enterState = false;
                    lastT = moveT;
                    lastMovement = GoblinMovement.MoveRight;
                    currentMovement = GoblinMovement.MoveLeft;
                }
                if (usePOI)
                {
                    enterState = false;
                    lastT = moveT;
                    lastMovement = GoblinMovement.MoveRight;
                    currentMovement = GoblinMovement.POI;
                }
                break;
            case GoblinMovement.POI:
                if (!enterState)
                {
                    moveT = 0;
                    enterState = true;
                }

                if (currentPOI)
                {
                    targetPos = (currentPOI.useOffset ? (Vector3)currentPOI.offset : currentPOI.transform.position) + Vector3.back * (Mathf.Abs(goblin.transform.position.z) + 21);
                }

                if (!usePOI)
                {
                    enterState = false;
                    lastT = moveT;
                    currentMovement = GoblinMovement.StandStill;
                }

                break;
        }
        switch (lastMovement)
        {
            case GoblinMovement.StandStill:
                lastTargetPos = goblin.transform.position + Vector3.back * 21;
                
                break;
            case GoblinMovement.MoveLeft:
                lastTargetPos = goblin.transform.position + (Vector3.left * offset) + (Vector3.back * 21);
                break;
            case GoblinMovement.MoveRight:
                lastTargetPos = goblin.transform.position + (Vector3.right * offset) + (Vector3.back * 21);
                break;
            case GoblinMovement.POI:
                lastTargetPos = (currentPOI.useOffset ? (Vector3)currentPOI.offset : currentPOI.transform.position) + Vector3.back * 21;
                break;
        }
        lastPos = Vector3.Lerp(lastTargetPos, targetPos, lastT);

        float size = goblin.sprinting ? standardSize -1 : standardSize;
        if (usePOI && currentPOI)
        {
            size = currentPOI.camSize;
        }

        moveT += Time.deltaTime * lerpSpeed * (goblin.currentAnimationState == CharacterController.AnimationState.Fall ? 2 : 1);
        moveT = Mathf.Clamp01(moveT);
        mainCam.orthographicSize = Mathf.Lerp(mainCam.orthographicSize, size, moveT * 0.5f);
        transform.position = Vector3.Lerp(transform.position, targetPos, moveT) + Vector3.up * (usePOI && currentPOI ? currentPOI.yCurve.Evaluate(moveT) : 0);
    }

    // Update is called once per frame
    void LateUpdate()
    {
        bool flag = false;
        // POI Check
        foreach(PointOfInterestHandler poi in pois)
        {
            if (poi.playerIsCloseEnough)
            {
                flag = true;
                currentPOI = poi;
            }
        }
        usePOI = flag;

        // Movement and Zoom
        if (!frogCamOverride)
        {
            //if (!usePOI)
            //{
            //    mainCam.orthographicSize = Mathf.Lerp(mainCam.orthographicSize, standardSize, lerpSpeed * Time.deltaTime);
            //    targetPos = new Vector3((goblin.transform.position + (goblinVelocity * forwardOffset)).x, goblin.transform.position.y, -21);
            //    Vector2 forwardPos = Vector2.Lerp(transform.position, targetPos, lerpSpeed * Time.deltaTime); // new Vector2(Mathf.Lerp(transform.position.x, targetPos.x, lerpSpeed * Time.deltaTime), goblin.transform.position.y, -21);
            //    Vector2 currentPos = Vector2.Lerp(transform.position, goblin.transform.position, lerpSpeed * Time.deltaTime); // new Vector3(Mathf.Lerp(transform.position.x, goblin.transform.position.x, lerpSpeed * Time.deltaTime), goblin.transform.position.y, -21);
            //    transform.position = (Vector3)(goblin.canMove ? forwardPos : currentPos) + Vector3.back * 21;
            //}
            //else if (usePOI && currentPOI)
            //{
            //    mainCam.orthographicSize = Mathf.Lerp(mainCam.orthographicSize, currentPOI.camSize, lerpSpeed * Time.deltaTime);
            //    Vector2 poiPos = Vector2.Lerp(transform.position, currentPOI.useOffset ? currentPOI.offset : (Vector2)currentPOI.transform.position, lerpSpeed * Time.deltaTime);
            //    transform.position = (Vector3)poiPos + Vector3.back * 21;
            //}

            MovementStateMachine();
        }
        else
        {
            FrogScript frog = goblin.mount.GetComponent<FrogScript>();
            mainCam.orthographicSize = Mathf.Lerp(mainCam.orthographicSize, frog.jumpDistance * sizePerDistance, Time.deltaTime);
            transform.position = Vector3.Lerp(transform.position, frog.arc.avgPosition + Vector3.back * 21, Time.deltaTime);
        }
    }
}
