extends Node2D

## 破军 - Screen Nuke skill
## Charge then release screen-wide damage (50 damage).

@export var charge_time: float = 0.8
@export var damage: int = 50
@export var cooldown: float = 15.0

var is_charging: bool = false

func start_charge() -> void:
	if not Global.player_node:
		queue_free()
		return

	is_charging = true
	Global.player_node.is_invulnerable = true
	Global.player_node.modulate = Color(1, 0.3, 0.3, 1)

	await get_tree().create_timer(charge_time).timeout

	if is_charging:
		release()

func release() -> void:
	if not Global.player_node:
		queue_free()
		return

	is_charging = false
	Global.player_node.is_invulnerable = false
	Global.player_node.modulate = Color.WHITE

	_damage_all_enemies()
	_spawn_ring_effect()
	queue_free()

func cancel_charge() -> void:
	if not Global.player_node:
		queue_free()
		return

	is_charging = false
	Global.player_node.is_invulnerable = false
	Global.player_node.modulate = Color.WHITE
	queue_free()

func _damage_all_enemies() -> void:
	var game = get_parent()
	if not game:
		return

	for child in game.get_children():
		if child.has_method("take_damage") and child != Global.player_node:
			child.take_damage(damage, Vector2.ZERO)

func _spawn_ring_effect() -> void:
	if not Global.player_node:
		return
	var ring = Node2D.new()
	ring.global_position = Global.player_node.global_position

	var circle = ColorRect.new()
	circle.size = Vector2(10, 10)
	circle.color = Color(1, 0.5, 0, 0.8)
	ring.add_child(circle)

	get_parent().add_child(ring)

	var tween = create_tween()
	tween.tween_property(circle, "size", Vector2(2000, 2000), 0.5)
	tween.tween_property(ring, "modulate:a", 0.0, 0.3)
	tween.tween_callback(ring.queue_free)