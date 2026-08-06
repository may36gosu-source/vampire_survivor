using TMPro;
using UnityEngine;

public class FPSOverlay : MonoBehaviour
{
    [SerializeField]
    private TextMeshProUGUI fpsText;

    private Transform player;

    private const float WARMUP_TIME = 1f;

    private float warmupTimer;

    private float timer;
    private int frameCount;

    private int fps;
    private float frameTime;

    private void Start()
    {
        GameObject playerObject = GameObject.FindWithTag(GameConst.TAG_PLAYER);

        if (playerObject != null)
        {
            player = playerObject.transform;
        }
    }

    private void Update()
    {
        if (!GameConfig.SHOW_FPS)
        {
            if (fpsText != null)
                fpsText.gameObject.SetActive(false);

            return;
        }

        if (!fpsText.gameObject.activeSelf)
            fpsText.gameObject.SetActive(true);

        warmupTimer += Time.unscaledDeltaTime;

        if (warmupTimer < WARMUP_TIME)
            return;

        // Bỏ qua frame bất thường
        if (Time.unscaledDeltaTime > 0.2f)
            return;

        frameCount++;
        timer += Time.unscaledDeltaTime;

        if (timer < GameConfig.FPS_UPDATE_INTERVAL)
            return;

        fps = Mathf.RoundToInt(frameCount / timer);
        frameTime = fps > 0 ? 1000f / fps : 0f;

        UpdateDebugText();

        frameCount = 0;
        timer = 0f;
    }

    private void UpdateDebugText()
    {
        if (player == null)
        {
            fpsText.text = $"FPS   : {fps}\n" + $"Frame : {frameTime:F1} ms";

            fpsText.color = GetFPSColor();
            return;
        }

        Vector3 pos = player.position;

        fpsText.text =
            $"FPS   : {fps}\n" +
            $"Frame : {frameTime:F1} ms\n" +
            $"Pos : {pos.x:F2}, {pos.z:F2}";
            // $"Pos Y : {pos.y:F2}\n" +
            // $"Pos Z : {pos.z:F2}";

        fpsText.color = GetFPSColor();
    }

    private Color GetFPSColor()
    {
        if (fps >= GameConfig.FPS_GOOD)
            return Color.green;

        if (fps >= GameConfig.FPS_WARNING)
            return Color.yellow;

        return Color.red;
    }
}