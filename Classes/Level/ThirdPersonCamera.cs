using UnityEngine;

public class ThirdPersonCamera : MonoBehaviour
{
    public Transform target;


    private readonly float Sensitivity = 0.001f;
    //private float currentX = 0.0f;
    //private float currentY = 0.0f;


    private void FixedUpdate()
    {
        //Quaternion rotation = Quaternion.Euler(currentX, currentY, 0);

        transform.position = Vector3.Slerp(transform.position, target.position, Time.deltaTime + Sensitivity);
        transform.rotation = Quaternion.Slerp(transform.rotation, target.rotation, Time.deltaTime + Sensitivity);
        //transform.LookAt(target.position);
    }
}
