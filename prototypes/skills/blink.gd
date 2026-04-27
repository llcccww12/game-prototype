extends Node2D

## 御风步 - Blink skill
## Short-distance teleport dealing 10 damage with i-frames on arrival.

@export var distance: float = 100.0
@export var damage: int = 10
@export var iframes_duration: float = 0.2
@export var cooldown: float = 3.0

func execute() -> void:
	if not Global.player_node:
		queue_free()
		return

	var player = Global.player_node
	var blink_dir = player.facing_direction
	if blink_dir == Vector2.ZERO:
		blink_dir = Vector2.RIGHT

	var start_pos = player.global_position
	var end_pos = start_pos + blink_dir * distance

	# Check for wall collision
	var space = player.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	var result = space.intersect_ray(query)
	if result.size() > 0:
		end_pos = result.position - blink_dir * 5

	_spawn_teleport_effect(start_pos)
	player.global_position = end_pos
	_damage_enemies_at(end_pos)

	player.is_invulnerable = true
	await get_tree().create_timer(iframes_duration).timeout
	if player:
		player.is_invulnerable = false
	_spawn_teleport_effect(end_pos)

	queue_free()

func _spawn_teleport_effect(pos: Vector2) -> void:
	var effect = Node2D.new()
	effect.global_position = pos

	var circle = ColorRect.new()
	circle.size = Vector2(30, 30)
	circle.color = Color(0.5, 0.8, 1, 0.5)
	effect.add_child(circle)

	get_parent().add_child(effect)

	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 0.3)
	tween.tween_callback(effect.queue_free)

func _damage_enemies_at(pos: Vector2) -> void:
	var space = Global.player_node.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = 2

	var enemies = space.intect_point(query, 10)
	for result in enemies:
		var enemy = result.collider
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage, Vector2.ZERO)
