
using UnityEngine;

public class VehicleController 
{
    public float[] SetSteer(float steer, float wheelBase, float turnRadius, float rearTrack)
    {
        float[] ackermanAngle = new float[2];

        if (steer > 0)
        {
            ackermanAngle[0] = Mathf.Rad2Deg * Mathf.Atan(wheelBase / (turnRadius + (rearTrack / 2))) * steer;
            ackermanAngle[1] = Mathf.Rad2Deg * Mathf.Atan(wheelBase / (turnRadius - (rearTrack / 2))) * steer;
        }
        else if (steer < 0)
        {
            ackermanAngle[0] = Mathf.Rad2Deg * Mathf.Atan(wheelBase / (turnRadius - (rearTrack / 2))) * steer;
            ackermanAngle[1] = Mathf.Rad2Deg * Mathf.Atan(wheelBase / (turnRadius + (rearTrack / 2))) * steer;
        }
        else
        {
            ackermanAngle[0] = 0;
            ackermanAngle[1] = 0;
        }

        return ackermanAngle;
    }
}
