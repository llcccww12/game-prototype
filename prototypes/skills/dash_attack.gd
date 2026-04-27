extends Node2D

## 飞燕回翔 - Dash Attack skill
## Dash forward through enemies dealing 15 damage, grants i-frames.

@export var damage: int = 15
@export var dash_distance: float = 150.0
@export var duration: float = 0.3
@export var cooldown: float = 4.0

var player: Node = null
var hit_enemies: Array = []

func _ready():
	player = get_node_or_null("/root/Game/Player")

func execute() -> void:
	if not player:
		return

	var start_pos = player.global_position
	var dash_dir = player.facing_direction
	if dash_dir == Vector2.ZERO:
		dash_dir = Vector2.RIGHT

	var end_pos = start_pos + dash_dir * dash_distance

	# Check for wall collision
	var space = player.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
	var result = space.intersect_ray(query)
	if result:
		end_pos = result.position - dash_dir * 10

	# Animate dash
	var tween = create_tween()
	tween.tween_property(player, "global_position", end_pos, duration)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT

	player.is_invulnerable = true

	# Check for enemies during dash
	for i in range(10):
		var t = float(i) / 10.0
		var check_pos = start_pos.lerp(end_pos, t)
		_damage_enemies_at(check_pos)

	await tween

	player.is_invulnerable = false
	queue_free()

func _damage_enemies_at(pos: Vector2) -> void:
	var space = player.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = 2  # Enemy layer

	var enemies = space.intersect_point(query, 10)
	for result in enemies:
		var enemy = result.collider
		if enemy is Enemy and enemy not in hit_enemies:
			hit_enemies.append(enemy)
			enemy.take_damage(damage, player.facing_direction * 50)
