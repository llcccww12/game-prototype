extends Enemy

## Melee enemy that chases the player.

func _ready():
	super._ready()
	max_hp = 30
	hp = 30
	move_speed = 80.0
	damage = 20

func _ai_behavior(delta: float) -> void:
	if not player_ref or is_dead:
		return

	var direction = (player_ref.global_position - global_position).normalized()
	velocity = direction * move_speed

	# Face player
	if direction.x < 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
