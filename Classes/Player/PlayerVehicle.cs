using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerVehicle : MonoBehaviour
{
    private float brake;
    private float gear;
    private float[] ackermanSteering = new float[2];

    private WheelHit hitLF;
    private WheelHit hitRF;
    private WheelHit hitLR;
    private WheelHit hitRR;

    private readonly AnimateWheel animateWheel = new AnimateWheel();
    private readonly ChaseCamera chaseCamera = new ChaseCamera();
    private readonly VehicleController vehicleController = new VehicleController();

    [Header("Dimensions")]
    [SerializeField] float wheelBase;
    [SerializeField] float rearTrack;
    [SerializeField] float turnRadius;

    [Header("WheelColliders")]
    [SerializeField] WheelCollider LF;
    [SerializeField] WheelCollider LR;
    [SerializeField] WheelCollider RF;
    [SerializeField] WheelCollider RR;

    [Header("Engine Torque")]
    [SerializeField] float throttleLF = 0;
    [SerializeField] float throttleLR = 0;
    [SerializeField] float throttleRF = 0;
    [SerializeField] float throttleRR = 0;

    [Header("Engine Torque")]
    [SerializeField] float torqueLF = 0;
    [SerializeField] float torqueLR = 0;
    [SerializeField] float torqueRF = 0;
    [SerializeField] float torqueRR = 0;

    [Header("Animation")]
    [SerializeField] GameObject wheelLF;
    [SerializeField] GameObject wheelLR;
    [SerializeField] GameObject wheelRF;
    [SerializeField] GameObject wheelRR;
    [SerializeField] GameObject caliperLF;
    [SerializeField] GameObject caliperLR;
    [SerializeField] GameObject caliperRF;
    [SerializeField] GameObject caliperRR;

    [Header("Camera")]
    [SerializeField] Transform lookTarget;
    [SerializeField] Transform followTarget;
    [SerializeField] float followSpeed;

    private void Start()
    {
        throttleLF = 0;
        throttleLR = 0;
        throttleRF = 0;
        throttleRR = 0;
        wheelBase = Vector3.Distance(LF.transform.position, LR.transform.position);
        rearTrack = Vector3.Distance(LR.transform.position, RR.transform.position);
    }

    private void Update()
    {
        CheckWin();
        ExitToMenu();

        animateWheel.AnimateWheels(wheelLF, caliperLF, LF);
        animateWheel.AnimateWheels(wheelLR, caliperLR, LR);
        animateWheel.AnimateWheels(wheelRF, caliperRF, RF);
        animateWheel.AnimateWheels(wheelRR, caliperRR, RR);

    }


    private void FixedUpdate()
    {
        Drive();
        chaseCamera.Follow(followTarget, lookTarget, followSpeed);

    }


    private void ExitToMenu()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene(0);
        }
    }


    private void Drive()
    {
        LF.motorTorque = throttleLF * gear;
        RF.motorTorque = throttleRF * gear;
        LR.motorTorque = throttleLR * gear;
        RR.motorTorque = throttleRR * gear;

        LF.steerAngle = ackermanSteering[0];
        RF.steerAngle = ackermanSteering[1];

        LR.brakeTorque = brake;
        LF.brakeTorque = brake;
        RF.brakeTorque = brake;
        RR.brakeTorque = brake;
    }

    private void CheckWin()
    {
        if (!LF || !RF || !LR || !RR)
        {
            return;
        }

        LF.GetGroundHit(out hitLF);
        RF.GetGroundHit(out hitRF);
        LR.GetGroundHit(out hitLR);
        RR.GetGroundHit(out hitRR);

        if (hitLF.collider == null)
        {
            return;
        }

        if (hitLF.collider.gameObject.name == "Area" &&
            hitRF.collider.gameObject.name == "Area" &&
            hitLR.collider.gameObject.name == "Area" &&
            hitRR.collider.gameObject.name == "Area" &&
            brake > 1000)
        {
            SceneManager.LoadScene(1);
        }
    }


    private void OnCollisionEnter(Collision collision)
    {
        if (collision.relativeVelocity.magnitude > 10)
        {
            SceneManager.LoadScene(2);
        }
    }


    public void SetThrottle(float newThrottle)
    {
        throttleLF = torqueLF * newThrottle;
        throttleLR = torqueLR * newThrottle;
        throttleRF = torqueRF * newThrottle;
        throttleRR = torqueRR * newThrottle;
    }

    public float GetThrottle()
    {
        return (throttleLF + throttleRF + throttleLR + throttleRR) / 4;
    }


    public void SetBrake(float newBrake)
    {
        brake = newBrake;
    }

    public void Steer(float newSteer)
    {
        ackermanSteering = vehicleController.SetSteer(newSteer, wheelBase, turnRadius, rearTrack);
    }

    public void SetGear(float newGear)
    {
        gear = newGear;
    }

}
