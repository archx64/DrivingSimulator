using UnityEngine;

public class AnimateWheel
{
    public void AnimateWheels(GameObject wheelMesh, GameObject brakeCaliper, WheelCollider wheelCollider)
    {
        if (!brakeCaliper || !wheelCollider)
        {
            return;
        }
        
        wheelCollider.GetWorldPose(out Vector3 wheelPosition, out Quaternion wheelRotation);
        brakeCaliper.transform.position = wheelPosition;
        brakeCaliper.transform.localEulerAngles = new Vector3(0, 0, wheelCollider.steerAngle);
        wheelMesh.transform.rotation = wheelRotation;
        wheelMesh.transform.position = wheelPosition;
    }

}