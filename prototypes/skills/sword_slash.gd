extends Node2D

## 剑气斩 - Melee AOE skill
## Forward fan-shaped melee attack dealing 30 damage.

@export var damage: int = 30
@export var range: float = 80.0
@export var angle: float = 60.0  # degrees
@export var duration: float = 0.3

var player: Node = null

func _ready():
	player = get_node_or_null("/root/Game/Player")

func execute() -> void:
	if not player:
		return

	# Create hitbox
	var hitbox = Area2D.new()
	hitbox.global_position = player.global_position + player.facing_direction * range / 2

	# Create fan-shaped collision
	var shape = Shape2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = _create_fan_shape()
	hitbox.add_child(collision)

	add_child(hitbox)

	# Check for enemies in range
	var enemies = hitbox.get_overlapping_bodies()
	for enemy in enemies:
		if enemy is Enemy:
			enemy.take_damage(damage, player.facing_direction * 100)

	# Animation
	modulate = Color(1, 0.5, 0, 0.5)

	await get_tree().create_timer(duration).timeout
	queue_free()

func _create_fan_shape() -> Shape2D:
	# Use a sector shape approximated by a polygon
	var points = PackedVector2Array()
	var angle_rad = deg_to_rad(angle)
	var half_angle = angle_rad / 2

	points.append(Vector2.ZERO)
	var segments = 8
	for i in range(segments + 1):
		var a = -half_angle + (angle_rad * i / segments)
		points.append(Vector2(cos(a), sin(a)) * range)

	var polygon = Polygon2D.new()
	polygon.polygon = points

	var shape = ConvexPolygonShape2D.new()
	shape.points = points
	return shape
