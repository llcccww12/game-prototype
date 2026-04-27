extends Node2D

## 剑气斩 - Melee AOE skill
## Forward fan-shaped melee attack dealing 30 damage.

@export var damage: int = 30
@export var range: float = 80.0
@export var angle: float = 60.0
@export var duration: float = 0.3

func _ready():
	modulate = Color(1, 0.5, 0, 0.5)

func execute() -> void:
	if not Global.player_node:
		queue_free()
		return

	var player = Global.player_node

	# Create hitbox
	var hitbox = Area2D.new()
	hitbox.global_position = player.global_position + player.facing_direction * range / 2

	# Create fan-shaped collision using ConvexPolygonShape2D
	var points = PackedVector2Array()
	var angle_rad = deg_to_rad(angle)
	var half_angle = angle_rad / 2
	points.append(Vector2.ZERO)
	var segments = 8
	for i in range(segments + 1):
		var a = -half_angle + (angle_rad * i / segments)
		points.append(Vector2(cos(a), sin(a)) * range)

	var shape = ConvexPolygonShape2D.new()
	shape.points = points
	var collision = CollisionShape2D.new()
	collision.shape = shape
	hitbox.add_child(collision)
	add_child(hitbox)

	# Check for enemies in range
	var enemies = hitbox.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage, player.facing_direction * 100)

	await get_tree().create_timer(duration).timeout
	queue_free()
