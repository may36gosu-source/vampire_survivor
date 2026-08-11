using System.Collections.Generic;
using UnityEngine;

public class HUDManager : MonoBehaviour
{

	[Header("HUD")]

    [SerializeField]
    private GameObject entityHUDPrefab;

    [SerializeField]
    private Transform entityHUDRoot;

	private ObjectPool entityHUDPool;
	private readonly Dictionary<Entity, EntityHUD> entityHUDs = new();

	private readonly List<Entity> entities = new(); // để biết trong map đng có entity nào

	[SerializeField]
	private float visibleDistance = 4f;

	private float timer;


	private void Awake()
	{
	    entityHUDPool = new ObjectPool(entityHUDPrefab, 20, entityHUDRoot);
	}

	private void OnEnable()
	{
	    GameEvents.OnEntityDamaged += HandleEntityDamaged;
	    GameEvents.OnEntityDead += HandleEntityDead;

	    GameEvents.OnEntitySpawn += RegisterEntity;
	}

	private void OnDisable()
	{
	    GameEvents.OnEntityDamaged -= HandleEntityDamaged;
	    GameEvents.OnEntityDead -= HandleEntityDead;

	    GameEvents.OnEntitySpawn -= RegisterEntity;
	}

	private void HandleEntityDamaged(Entity entity)
	{
		// if (!entityHUDs.TryGetValue(entity, out EntityHUD hud))
	    // {
	    //     hud = CreateHUD(entity);
	    // }
		EntityHUD hud = EnsureHUD(entity);
	    hud.RefreshHP();

	    // Debug.Log($"Create HUD : {entity.Id}");
	}


	//=== các api xử lý các đối tượng trong map
	private void RegisterEntity(Entity entity)
	{
	    if (entities.Contains(entity))
	        return;

	    entities.Add(entity);

	    // tạo HUD cho player
	    if (entity is PlayerController)
	    {
	        EnsureHUD(entity);
	    }
	}

	private void UnregisterEntity(Entity entity)
	{
	    entities.Remove(entity);

	    RemoveHUD(entity);
	}

	private void RemoveHUD(Entity entity)
	{
	    if (!entityHUDs.TryGetValue(entity, out EntityHUD hud))
	        return;

	    entityHUDPool.Release(hud.gameObject);

	    entityHUDs.Remove(entity);
	}

	private EntityHUD EnsureHUD(Entity entity)
	{
	    if (entityHUDs.TryGetValue(entity, out EntityHUD hud))
	        return hud;

	    return CreateHUD(entity);
	}


	private void Update()
	{
	    timer += Time.deltaTime;

	    if (timer < 0.2f)
	        return;

	    timer = 0f;

	    UpdateVisibleHUD();
	}


	private void LateUpdate()
	{
	    UpdateHUDPositions();
	}

	private void UpdateHUDPositions()
	{
	    foreach (EntityHUD hud in entityHUDs.Values)
	    {
	        if (hud == null)
	            continue;

	        hud.UpdatePosition();
	    }
	}


	private void UpdateVisibleHUD()
	{
	    Transform player = LocalPlayer.Transform;

	    if (player == null)
	        return;

	    foreach (Entity entity in entities)
	    {
	        if (entity == null || entity.IsDead)
	            continue;

	        float distance = Vector3.Distance(player.position, entity.Position);

	        bool visible = distance <= visibleDistance;

	        if (visible)
	        {
	            if (!entityHUDs.ContainsKey(entity))
	            {
	                CreateHUD(entity);
	            }
	        }
	        else
	        {
	            RemoveHUD(entity);
	        }
	    }
	}

	


	private void HandleEntityDead(Entity entity)
	{
		UnregisterEntity(entity);
	}


	private EntityHUD CreateHUD(Entity entity)
	{
	    GameObject obj = entityHUDPool.Get();

	    EntityHUD hud = obj.GetComponent<EntityHUD>();

	    hud.Bind(entity);

	    entityHUDs.Add(entity, hud);

	    return hud;
	}
}