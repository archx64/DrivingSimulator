﻿using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Timer : MonoBehaviour
{
    private Text text;

    public static float time;
    private void Start()
    {
        text = GetComponent<Text>();
        time = 90;
    }

    private void Update()
    {
        time -= Time.deltaTime;

        if (time <= 0)
        {
            SceneManager.LoadScene(2);
        }

        text.text = Mathf.RoundToInt(time).ToString();
    }
}
