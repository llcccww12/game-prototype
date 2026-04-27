extends Node2D

## 破军 - Screen Nuke skill
## Charge then release screen-wide damage (50 damage).

@export var charge_time: float = 0.8
@export var damage: int = 50
@export var cooldown: float = 15.0

var player: Node = null
var is_charging: bool = false

func _ready():
	player = get_node_or_null("/root/Game/Player")

func start_charge() -> void:
	if not player:
		return

	is_charging = true
	player.is_invulnerable = true

	# Visual feedback - player glows
	player.modulate = Color(1, 0.3, 0.3, 1)

	await get_tree().create_timer(charge_time).timeout

	if is_charging:
		release()

func release() -> void:
	if not player:
		return

	is_charging = false
	player.is_invulnerable = false
	player.modulate = Color.WHITE

	# Damage all enemies on screen
	_damage_all_enemies()

	# Visual effect - expanding ring
	_spawn_ring_effect()

	queue_free()

func cancel_charge() -> void:
	if not player:
		return

	is_charging = false
	player.is_invulnerable = false
	player.modulate = Color.WHITE
	queue_free()

func _damage_all_enemies() -> void:
	var game = get_parent()
	if not game:
		return

	for child in game.get_children():
		if child is Enemy:
			child.take_damage(damage, Vector2.ZERO)

func _spawn_ring_effect() -> void:
	var ring = Node2D.new()
	ring.position = player.global_position

	var circle = ColorRect.new()
	circle.size = Vector2(10, 10)
	circle.color = Color(1, 0.5, 0, 0.8)
	ring.add_child(circle)

	get_parent().add_child(ring)

	var tween = create_tween()
	tween.tween_property(circle, "size", Vector2(2000, 2000), 0.5)
	tween.tween_property(ring, "modulate:a", 0.0, 0.3)
	tween.tween_callback(ring.queue_free)
