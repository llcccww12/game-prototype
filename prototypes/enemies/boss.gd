extends Enemy

## Boss enemy with multiple attack patterns and phases.

signal died

@export var max_hp: int = 300
@export var phase2_threshold: float = 0.5  # 50% HP

enum AttackPattern { CHARGE, SLAM, SUMMON }
var current_pattern: AttackPattern = AttackPattern.CHARGE
var pattern_timer: float = 3.0

var is_charging: bool = false
var is_slamming: bool = false
var charge_target: Vector2 = Vector2.ZERO

var phase_2: bool = false

func _ready():
	super._ready()
	max_hp = 300
	hp = 300
	move_speed = 80.0
	damage = 40

func _ai_behavior(delta: float) -> void:
	if not player_ref or is_dead:
		return

	# Check phase transition
	if not phase_2 and float(hp) / max_hp <= phase2_threshold:
		_enter_phase_2()

	# Pattern cycling
	pattern_timer -= delta
	if pattern_timer <= 0:
		_next_pattern()
		pattern_timer = 3.0

	match current_pattern:
		AttackPattern.CHARGE:
			_charge_behavior(delta)
		AttackPattern.SLAM:
			_slam_behavior(delta)
		AttackPattern.SUMMON:
			_summon_behavior(delta)

func _enter_phase_2() -> void:
	phase_2 = true
	move_speed *= 1.3
	pattern_timer = 1.0
	# Visual indication of phase 2
	modulate = Color(1.5, 0.8, 0.8, 1)

func _next_pattern() -> void:
	var patterns = AttackPattern.values()
	var next_index = (current_pattern + 1) % patterns.size()
	current_pattern = patterns[next_index]

	match current_pattern:
		AttackPattern.SUMMON:
			pattern_timer = 2.0

func _charge_behavior(delta: float) -> void:
	if not is_charging:
		# Start charge
		is_charging = true
		charge_target = player_ref.global_position

	var direction = (charge_target - global_position).normalized()
	velocity = direction * move_speed * 2.0

	if global_position.distance_to(charge_target) < 20:
		is_charging = false
		await get_tree().create_timer(0.5).timeout
		pattern_timer = 0

func _slam_behavior(delta: float) -> void:
	if not is_slamming:
		# Jump and slam
		is_slamming = true
		velocity = Vector2.UP * -200

	await get_tree().create_timer(0.3).timeout
	if is_slamming:
		# Slam down - AoE damage
		_do_slam_aoe()
		is_slamming = false
		pattern_timer = 0

func _do_slam_aoe() -> void:
	var aoe_radius = 150.0
	var slam_damage = 30

	if player_ref and global_position.distance_to(player_ref.global_position) < aoe_radius:
		player_ref.take_damage(slam_damage)

	# Visual effect (screen shake)
	var game = get_parent()
	if game:
		game.camera_shake()

func _summon_behavior(delta: float) -> void:
	# Summon 2 melee minions
	velocity = Vector2.ZERO

	var melee_scene = preload("res://enemies/melee_enemy.tscn")
	for i in range(2):
		var minion = melee_scene.instantiate()
		minion.position = global_position + Vector2.RIGHT.rotated(i * PI) * 50
		minion.player_ref = player_ref
		get_parent().add_child(minion)

	pattern_timer = 0

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	# Boss takes reduced damage during certain attacks
	if is_charging:
		amount = int(amount * 0.5)

	super.take_damage(amount, knockback)

func _die() -> void:
	is_dead = true
	emit_signal("died")

	# Longer death animation
	modulate = Color(0.3, 0.3, 0.3, 0.3)

	await get_tree().create_timer(1.0).timeout
	queue_free()
