using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class SkillButton : MonoBehaviour
{
    [Header("UI")]
    [SerializeField]
    private Image icon;

    [SerializeField]
    private Image cooldownOverlay;

    [SerializeField]
    private TMP_Text cooldownText;

    [SerializeField]
    private Button button;

    private SkillManager skillManager;

    private SkillData skill;

    public SkillData Skill => skill;

    // ========================================
    // INITIALIZE
    // ========================================

   

    public void Initialize(SkillData sk, SkillManager skillManager)
    {
        if (sk == null)
            return;

        this.skillManager = skillManager;
        this.skill = sk;

        if (icon != null)
        {
            icon.sprite = sk.Icon;
        }

        // if (cooldownOverlay != null)
        // {
        //     cooldownOverlay.sprite = sk.Icon;

        //     // Màu đen trong suốt
        //     cooldownOverlay.color = new Color(0f, 0f, 0f, 0.65f);

        //     // Ép overlay nằm trên Icon
        //     cooldownOverlay.transform.SetAsLastSibling();

        //     // Text phải nằm trên overlay
        //     if (cooldownText != null)
        //     {
        //         cooldownText.transform.SetAsLastSibling();
        //     }

        //     cooldownOverlay.fillAmount = 0f;
        //     cooldownOverlay.raycastTarget = false;
        // }
        if (cooldownOverlay != null)
        {
            cooldownOverlay.sprite = sk.Icon;
            cooldownOverlay.color = new Color(0f, 0f, 0f, 0.65f);

            cooldownOverlay.fillMethod = Image.FillMethod.Radial360;
            cooldownOverlay.fillOrigin = (int)Image.Origin360.Bottom;
            cooldownOverlay.fillClockwise = false;

            cooldownOverlay.transform.SetAsLastSibling();

            if (cooldownText != null)
                cooldownText.transform.SetAsLastSibling();

            cooldownOverlay.fillAmount = 0f;
        }

        ResetCooldown();

        if (button != null)
        {
            button.onClick.RemoveAllListeners();
            button.onClick.AddListener(HandleClick);
        }
    }

    private void HandleClick()
    {
        if (skillManager == null)
            return;

        skillManager.TryUseSkill(skill);
    }


    // ========================================
    // COOLDOWN
    

    public void SetCooldown(float remaining, float duration)
    {
        if (cooldownOverlay != null)
        {
            cooldownOverlay.enabled = true;
            cooldownOverlay.color = new Color(0f, 0f, 0f, 0.65f);

            if (duration <= 0f)
            {
                cooldownOverlay.fillAmount = 0f;
            }
            else
            {
                cooldownOverlay.fillAmount =
                    Mathf.Clamp01(remaining / duration);
            }
        }

        if (cooldownText != null)
        {
            cooldownText.text = remaining > 0f ? remaining.ToString("F1") : "";
        }
    }


    public void ResetCooldown()
    {
        if (cooldownOverlay != null)
        {
            cooldownOverlay.fillAmount = 0f;
        }

        if (cooldownText != null)
        {
            cooldownText.text = "";
        }
    }



}