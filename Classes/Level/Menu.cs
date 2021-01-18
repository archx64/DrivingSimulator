using UnityEngine.SceneManagement;
using UnityEngine;

public class Menu : MonoBehaviour
{
    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.Escape))
        {
            Application.Quit();
        }
    }

    public void SceneLoad(int index)
    {
        SceneManager.LoadScene(index);
    }
}
