using UnityEngine.SceneManagement;
using UnityEngine;
using System.Collections;

public class SceneLoader : MonoBehaviour
{

    private void Update()
    {
        StartCoroutine(LoadMenu());
    }

    private IEnumerator LoadMenu()
    {
        yield return new WaitForSeconds(3);
        SceneManager.LoadScene(0);
    }
}
