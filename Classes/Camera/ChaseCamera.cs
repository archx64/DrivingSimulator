using UnityEngine;

public class ChaseCamera
{
    public void Follow(Transform followTarget, Transform lookTarget, float followSpeed)
    {
        Vector3 smoothPostion = Vector3.Lerp(Camera.main.transform.position, followTarget.position, followSpeed * Time.deltaTime);
        Camera.main.transform.position = smoothPostion;
        Camera.main.transform.LookAt(lookTarget);
    }
}
