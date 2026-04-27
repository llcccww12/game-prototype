extends Area2D

## Arrow projectile fired by ranged enemies.

@export var speed: float = 300.0
@export var damage: int = 15
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var velocity: Vector2 = Vector2.ZERO

func _ready():
	velocity = direction * speed
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float):
	position += velocity * delta
	lifetime -= delta

	if lifetime <= 0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.take_damage(damage)
		queue_free()
	elif body is Enemy:
		# Don't hit other enemies
		pass
	else:
		queue_free()
