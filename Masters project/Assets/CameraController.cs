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

    public PointOfInterestHandler currentPOI;
    public static List<PointOfInterestHandler> pois = new List<PointOfInterestHandler>();
    public bool usePOI = false;
    public float standardSize;

    public Vector3 goblinVelocity;
    private Vector3 targetPos;
    void Awake()
    {
        mainCam = GetComponent<Camera>();
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
        // Movement
        targetPos = new Vector3((goblin.transform.position + (goblinVelocity * forwardOffset)).x, 0, -21);
        Vector3 forwardPos = new Vector3(Mathf.Lerp(transform.position.x, targetPos.x, lerpSpeed * Time.deltaTime), goblin.transform.position.y, -21);
        Vector3 currentPos = new Vector3(Mathf.Lerp(transform.position.x, goblin.transform.position.x, lerpSpeed * Time.deltaTime), goblin.transform.position.y, -21);
        transform.position = goblin.canMove ? forwardPos : currentPos;

        // Zoom
        if (!usePOI)
        {
            mainCam.orthographicSize = Mathf.Lerp(mainCam.orthographicSize, standardSize, lerpSpeed * Time.deltaTime);
        }
        else if (usePOI && currentPOI)
        {
            mainCam.orthographicSize = Mathf.Lerp(mainCam.orthographicSize, currentPOI.camSize, lerpSpeed * Time.deltaTime);
        }
    }
}
