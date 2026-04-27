extends Enemy

## Ranged enemy that shoots arrows at the player.

@export var preferred_distance: float = 150.0
@export var shoot_cooldown: float = 2.0
@export var arrow_speed: float = 300.0
@export var arrow_damage: int = 15

var shoot_timer: float = 0.0
var is_retreating: bool = false

func _ready():
	super._ready()
	max_hp = 20
	hp = 20
	move_speed = 60.0
	damage = 0  # Ranged enemy doesn't do contact damage

func _ai_behavior(delta: float) -> void:
	if not player_ref or is_dead:
		return

	shoot_timer -= delta

	var to_player = player_ref.global_position - global_position
	var distance = to_player.length()
	var direction = to_player.normalized()

	# Try to maintain preferred distance
	if distance < preferred_distance - 30:
		# Too close, retreat
		velocity = -direction * move_speed
		is_retreating = true
	elif distance > preferred_distance + 30:
		# Too far, approach
		velocity = direction * move_speed * 0.5
		is_retreating = false
	else:
		# In range, strafe slightly
		velocity = Vector2.ZERO
		is_retreating = false

	# Face player
	if direction.x < 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

	# Shoot if cooldown ready
	if shoot_timer <= 0 and not is_retreating:
		_shoot_arrow(direction)
		shoot_timer = shoot_cooldown

func _shoot_arrow(direction: Vector2) -> void:
	var arrow = preload("res://enemies/arrow.tscn").instantiate()
	arrow.direction = direction
	arrow.speed = arrow_speed
	arrow.damage = arrow_damage
	arrow.global_position = global_position
	get_parent().add_child(arrow)
