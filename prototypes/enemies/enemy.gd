extends CharacterBody2D
class_name Enemy

## Base class for all enemies.

signal died

@export var max_hp: int = 30
@export var move_speed: float = 80.0
@export var damage: int = 20
@export var contact_cooldown: float = 1.0

var hp: int = 30
var player_ref: Node = null
var last_contact_time: float = 0.0
var is_dead: bool = false

func _ready():
	hp = max_hp

func _physics_process(delta: float):
	if is_dead or not player_ref:
		velocity = Vector2.ZERO
		return

	# AI behavior (overridden in subclasses)
	_ai_behavior(delta)

	move_and_slide()

func _ai_behavior(delta: float) -> void:
	# Override in subclasses
	pass

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	if is_dead:
		return

	hp -= amount

	# Apply knockback
	if knockback != Vector2.ZERO:
		velocity = knockback.normalized() * 200

	if hp <= 0:
		_die()
	else:
		# Flash red
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE

func _die() -> void:
	is_dead = true
	emit_signal("died")

	# Death animation
	modulate = Color(0.5, 0.5, 0.5, 0.5)

	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_body_entered(body: Node) -> void:
	if is_dead:
		return

	if body.name == "Player" and Time.get_ticks_msec() / 1000.0 - last_contact_time >= contact_cooldown:
		if not body.is_invulnerable:
			body.take_damage(damage)
			last_contact_time = Time.get_ticks_msec() / 1000.0
