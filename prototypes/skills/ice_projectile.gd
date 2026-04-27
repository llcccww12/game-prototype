extends Area2D

## 冰魄掌 - Ice Projectile skill
## Fire an ice projectile that deals 25 damage and knocks back.

@export var speed: float = 400.0
@export var damage: int = 25
@export var knockback: float = 50.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT
var velocity: Vector2 = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)

func initialize(dir: Vector2, source: Node) -> void:
	direction = dir
	velocity = direction * speed

	# Face direction
	if direction.x < 0:
		$Sprite2D.flip_h = true

func _physics_process(delta: float):
	position += velocity * delta
	lifetime -= delta

	if lifetime <= 0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		body.take_damage(damage, direction * knockback)
		queue_free()
	elif body is StaticBody2D:
		queue_free()
