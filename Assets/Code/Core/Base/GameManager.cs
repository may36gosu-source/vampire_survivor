using UnityEngine;


public enum GameState
{
    Ready,
    Playing
}

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    public GameState State { get; private set; }

    private void Awake()
    {
        Instance = this;

        State = GameState.Ready;
    }

    public void StartGame()
    {
        if (State != GameState.Ready)
        return;

        State = GameState.Playing;

        GameEvents.GameStarted();
    }
}