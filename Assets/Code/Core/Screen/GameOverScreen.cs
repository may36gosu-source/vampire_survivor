using UnityEngine;
using UnityEngine.SceneManagement;

public class GameOverScreen : MonoBehaviour
{
    [SerializeField]
    private GameObject panel;

    private GameObject fixedJoystick;

    private GameObject playerStatusHUD;


    private void Awake()
    {
        panel.SetActive(false);


        fixedJoystick = GameObject.Find("Fixed Joystick");


        PlayerStatusHUD hud = FindFirstObjectByType<PlayerStatusHUD>();


        if (hud != null)
        {
            playerStatusHUD = hud.gameObject;
        }
    }


    private void OnEnable()
    {
        GameEvents.OnGameOver += Show;
    }


    private void OnDisable()
    {
        GameEvents.OnGameOver -= Show;
    }


    private void Show()
    {
        // ====================================
        // HIDE GAMEPLAY UI
        // ====================================

        if (fixedJoystick != null)
        {
            fixedJoystick.SetActive(false);
        }


        if (playerStatusHUD != null)
        {
            playerStatusHUD.SetActive(false);
        }


        // ====================================
        // SHOW GAME OVER
        // ====================================

        panel.SetActive(true);
    }


    public void Restart()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
}