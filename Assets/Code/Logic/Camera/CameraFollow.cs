using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    [Header("Target")]
    [SerializeField] private Transform target;

    [Header("Focus")]
    [SerializeField] private Vector3 focusOffset = new Vector3(0f, 1.5f, 0f);

    [Header("Camera")]
    [SerializeField] private float distance = 8f;
    [SerializeField] private float pitch = 35f;
    [SerializeField] private float yaw = 0f;

    [Header("Follow")]
    [SerializeField] private float smoothSpeed = 8f;

    private void LateUpdate()
    {
        if (target == null)
            return;

        // Điểm camera nhìn vào (đầu/ngực nhân vật)
        Vector3 focusPoint =
            target.position + focusOffset;

        // Góc quay camera
        Quaternion rotation =
            Quaternion.Euler(pitch, yaw, 0f);

        // Vị trí camera mong muốn
        Vector3 desiredPosition =
            focusPoint -
            rotation * Vector3.forward * distance;

        // Smooth Follow
        transform.position =
            Vector3.Lerp(
                transform.position,
                desiredPosition,
                smoothSpeed * Time.deltaTime);

        // Camera luôn nhìn vào nhân vật
        transform.rotation = rotation;
    }
}