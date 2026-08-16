using System.Collections.Generic;
using UnityEngine;

public class SkillBar : MonoBehaviour
{
    [Header("Skill")]
    [SerializeField]
    private List<SkillData> skills = new();

    [Header("UI")]
    [SerializeField]
    private SkillButton skillButtonPrefab;

    [SerializeField]
    private Transform skillButtonRoot;

    [Header("Circle Layout")]
    [SerializeField]
    private float radius = 110f;

    [SerializeField]
    private float startAngle = 90f;

    [SerializeField]
    private float endAngle = 180f;

    private readonly List<SkillButton> skillButtons = new();

    [Header("Gameplay")]
    [SerializeField]
    private SkillManager skillManager;

    private void Start()
    {
        BuildSkillButtons();
        ArrangeButtons();
    }

    private void ArrangeButtons()
    {
        int count = skillButtons.Count;

        if (count == 0)
            return;

        for (int i = 0; i < count; i++)
        {
            float t;

            if (count == 1)
            {
                t = 0.5f;
            }
            else
            {
                t = (float)i / (count - 1);
            }

            float angle = Mathf.Lerp(startAngle, endAngle, t );

            float radians = angle * Mathf.Deg2Rad;

            Vector2 position = new Vector2( Mathf.Cos(radians), Mathf.Sin(radians)) * radius;

            RectTransform rect = skillButtons[i].GetComponent<RectTransform>();

            rect.anchoredPosition = position;

            Debug.Log($"Skill {i} | " + $"Angle={angle} | " + $"Position={position}");
        }
    }

    private void UpdateCooldownUI()
    {
        if (skillManager == null)
            return;

        foreach (SkillButton button in skillButtons)
        {
            if (button == null)
                continue;

            SkillData skill = button.Skill;

            float remaining = skillManager.GetCooldownRemaining(skill);

                // Debug.Log(
                //     $"Cooldown UI | " +
                //     $"Skill={skill.name} | " +
                //     $"Remaining={remaining:F2} | " +
                //     $"Duration={skill.Cooldown:F2}"
                // );

            button.SetCooldown(
                remaining,
                skill.Cooldown
            );
        }
    }

    private void BuildSkillButtons()
    {
        ClearSkillButtons();

        foreach (SkillData skill in skills)
        {
            if (skill == null)
                continue;

            if (skillButtonPrefab == null)
            {
                Debug.LogError("SkillBar: Chưa gán SkillButton Prefab.", this);

                return;
            }

            SkillButton button = Instantiate(skillButtonPrefab, skillButtonRoot);

            button.Initialize( skill, skillManager);

            skillButtons.Add(button);
        }
    }

    private void ClearSkillButtons()
    {
        foreach (SkillButton button in skillButtons)
        {
            if (button == null)
                continue;

            Destroy(button.gameObject);
        }

        skillButtons.Clear();
    }

    private void Update()
    {
        UpdateCooldownUI();
    }
}