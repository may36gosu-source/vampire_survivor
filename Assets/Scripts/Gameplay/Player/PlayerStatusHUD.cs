using TMPro;
using UnityEngine;

public class PlayerStatusHUD : MonoBehaviour
{
    [SerializeField]
    private TextMeshProUGUI levelText;

    [SerializeField]
    private TextMeshProUGUI hpText;

    [SerializeField]
    private TextMeshProUGUI attackText;

    [SerializeField]
    private TextMeshProUGUI expText;

    private PlayerController player;

    private void Start()
    {
        player = LocalPlayer.Instance;

        if (player == null)
        {
            Debug.LogError("PlayerStatusHUD: Player not found.");
            return;
        }

        Refresh();
    }

    private void Awake()
    {
        // gameObject.SetActive( GameStateHelper.IsPlaying());
    }

    private void Update()
    {
        if (player == null)
            return;

        if (!GameStateHelper.IsPlaying())
        return;

        Refresh();
    }

    private void Refresh()
    {
        levelText.text = $"LEVEL: {player.CurrentLevel}";

        hpText.text = $"HP: {player.CurrentHP} / {player.MaxHP}";

        attackText.text = $"ATK: {player.CurrentAttack}";

        expText.text = $"EXP: {player.CurrentExp} / {player.ExpToNextLevel}";
    }
}