using UnityEngine;

public class CheckPoint : MonoBehaviour
{
    public bool score;
    public bool penalty;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            if (score)
            {
                Timer.time += 10;
            }
            else if(penalty)
            {
                Timer.time -= 20;
            }
        }
    }
}
