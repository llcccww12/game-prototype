extends Node2D

## 御风步 - Blink skill
## Short-distance teleport dealing 10 damage with i-frames on arrival.

@export var distance: float = 100.0
@export var damage: int = 10
@export var iframes_duration: float = 0.2
@export var cooldown: float = 3.0

var player: Node = null

func _ready():
	player = get_node_or_null("/root/Game/Player")

func execute() -> void:
	if not player:
		return

	var blink_dir = player.facing_direction
	if blink_dir == Vector2.ZERO:
		blink_dir = Vector2.RIGHT

	var start_pos = player.global_position
	var end_pos = start_pos + blink_dir * distance

	# Check for wall collision
	var space = player.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	var result = space.intersect_ray(query)
	if result:
		end_pos = result.position - blink_dir * 5

	# Teleport effect at start
	_spawn_teleport_effect(start_pos)

	player.global_position = end_pos

	# Damage enemies at arrival point
	_damage_enemies_at(end_pos)

	# Grant i-frames
	player.is_invulnerable = true
	await get_tree().create_timer(iframes_duration).timeout
	player.is_invulnerable = false

	# Teleport effect at end
	_spawn_teleport_effect(end_pos)

	queue_free()

func _spawn_teleport_effect(pos: Vector2) -> void:
	var effect = Node2D.new()
	effect.position = pos

	var circle = ColorRect.new()
	circle.size = Vector2(30, 30)
	circle.modulate = Color(0.5, 0.8, 1, 0.5)
	effect.add_child(circle)

	get_parent().add_child(effect)

	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 0.3)
	tween.tween_callback(effect.queue_free)

func _damage_enemies_at(pos: Vector2) -> void:
	var space = player.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = 2

	var enemies = space.intersect_point(query, 10)
	for result in enemies:
		var enemy = result.collider
		if enemy is Enemy:
			enemy.take_damage(damage, Vector2.ZERO)
