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

    public PointOfInterestHandler currentPOI;
    public static List<PointOfInterestHandler> pois = new List<PointOfInterestHandler>();
    public bool usePOI = false;
    public float standardSize;

    public Vector3 goblinVelocity;
    private Vector3 targetPos;
    void Awake()
    {
        mainCam = GetComponent<Camera>();
        mainCamController = this;
    }
    // Start is called before the first frame update
    void Start()
    {
        rb = goblin.GetComponent<Rigidbody2D>();
    }

    public void FixedUpdate()
    {
        goblinVelocity = goblin.velocity.normalized * (goblin.sprinting ? 1 : 0.75f);
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
        if (!usePOI)
        {
            mainCam.orthographicSize = Mathf.Lerp(mainCam.orthographicSize, standardSize, lerpSpeed * Time.deltaTime);
            targetPos = new Vector3((goblin.transform.position + (goblinVelocity * forwardOffset)).x, goblin.transform.position.y, -21);
            Vector2 forwardPos = Vector2.Lerp(transform.position, targetPos, lerpSpeed * Time.deltaTime); // new Vector2(Mathf.Lerp(transform.position.x, targetPos.x, lerpSpeed * Time.deltaTime), goblin.transform.position.y, -21);
            Vector2 currentPos = Vector2.Lerp(transform.position, goblin.transform.position, lerpSpeed * Time.deltaTime); // new Vector3(Mathf.Lerp(transform.position.x, goblin.transform.position.x, lerpSpeed * Time.deltaTime), goblin.transform.position.y, -21);
            transform.position = (Vector3)(goblin.canMove ? forwardPos: currentPos) + Vector3.back * 21;
        }
        else if (usePOI && currentPOI)
        {
            mainCam.orthographicSize = Mathf.Lerp(mainCam.orthographicSize, currentPOI.camSize, lerpSpeed * Time.deltaTime);
            Vector2 poiPos = Vector2.Lerp(transform.position, currentPOI.useOffset ? currentPOI.offset : (Vector2)currentPOI.transform.position, lerpSpeed * Time.deltaTime);
            transform.position = (Vector3)poiPos + Vector3.back * 21;
        }
    }
}
