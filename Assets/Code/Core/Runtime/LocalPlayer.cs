using UnityEngine;

public static class LocalPlayer
{
    public static PlayerController Instance { get; private set; }

    public static void Register(PlayerController player)
    {
        Instance = player;
    }

    public static void Unregister(PlayerController player)
    {
        if (Instance == player)
        {
            Instance = null;
        }
    }

    public static Transform Transform => Instance != null ? Instance.transform : null;
}