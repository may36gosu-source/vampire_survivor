using UnityEngine;

public class StartScreen : MonoBehaviour
{
    private GameObject fixedJoystick;

    private GameObject playerStatusHUD;


    private void Awake()
    {
        fixedJoystick = GameObject.Find("Fixed Joystick");

        if (fixedJoystick != null)
        {
            fixedJoystick.SetActive(false);
        }

        PlayerStatusHUD hud = FindFirstObjectByType<PlayerStatusHUD>();

        if (hud != null)
        {
            playerStatusHUD = hud.gameObject;
            playerStatusHUD.SetActive(false);
        }
    }


    public void StartGame()
    {
        GameManager.Instance.StartGame();

        if (fixedJoystick != null)
        {
            fixedJoystick.SetActive(true);
        }

        if (playerStatusHUD != null)
        {   
            
            playerStatusHUD.SetActive(true);
        }

        gameObject.SetActive(false);
    }
}