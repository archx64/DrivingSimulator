using UnityEngine;
using UnityEngine.SceneManagement;

[RequireComponent(typeof(CarController))]
public class CarUserControl : MonoBehaviour
{
    private CarController m_Car; // the car controller we want to use
    private readonly ChaseCamera chaseCamera = new ChaseCamera();

    public Transform lookAt;
    public Transform pivot;

    private float throttle;
    private float steer;

    private float handbrake;

    public void ChangeCamera(float value)
    {
        Camera.main.fieldOfView = value;   
    }

    public void Throttle(float value)
    {
        throttle = value;
    }    
    public void Steer(float value)
    {
        steer = value;
    }

    public void Handbrake(float value)
    {
        handbrake = value;
    }


    private void Awake()
    {
        // get the car controller
        m_Car = GetComponent<CarController>();
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.relativeVelocity.magnitude > 5)
        {
            SceneManager.LoadScene(2);
        }
    }

    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.Escape))
        {
            SceneManager.LoadScene(0);
        }
    }

    private void FixedUpdate()
    {
        chaseCamera.Follow(pivot, lookAt, 10);
        // pass the input to the car!

        m_Car.Move(steer, throttle, throttle, handbrake);

//#if !MOBILE_INPUT
//        float h = Input.GetAxis("Horizontal");
//        float v = Input.GetAxis("Vertical");
//        float handbrake = Input.GetAxis("Jump");
//        m_Car.Move(h, v, v, handbrake);
//#else
//        m_Car.Move(h, v, v, );
//#endif
    }

    
}

