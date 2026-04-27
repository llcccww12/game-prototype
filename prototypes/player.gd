extends CharacterBody2D
class_name Player

## Player character with touch-based joystick movement.
## Extends CharacterBody2D for top-down action game.

signal health_changed(current: int, max_val: int)
signal stamina_changed(current: int, max_val: int)
signal died
signal combo_hit(hit_number: int)

# Movement
@export var move_speed: float = 200.0
@export var joystick_dead_zone: float = 0.1

# Stats
@export var max_hp: int = 100
@export var max_stamina: int = 100
@export var stamina_regen_rate: float = 10.0  # per second

var hp: int = 100
var stamina: float = 100.0

# Direction
var facing_direction: Vector2 = Vector2(1, 0)

# State
enum { STATE_MENU, STATE_PLAYING, STATE_PAUSED, STATE_DEAD, STATE_VICTORY }
var game_state: int = STATE_MENU

# Combat
var combo_count: int = 0
var combo_timer: float = 0.0
const COMBO_WINDOW: float = 0.4
const DODGE_COST: float = 20.0
const DODGE_COOLDOWN: float = 0.5
const DODGE_DURATION: float = 0.3
const IFRAMES_DURATION: float = 0.3

var is_dodging: bool = false
var dodge_timer: float = 0.0
var dodge_cooldown_timer: float = 0.0
var is_invulnerable: bool = false
var invulnerability_timer: float = 0.0

# Skills (cooldowns in seconds)
var skill_cooldowns: Dictionary = {
	"skill_1": 0.0,  # 剑气斩 - 5s
	"skill_2": 0.0,  # 飞燕回翔 - 4s
	"skill_3": 0.0,  # 冰魄掌 - 6s
	"skill_4": 0.0,  # 御风步 - 3s
	"skill_5": 0.0,  # 破军 - 15s
}

var skill_max_cooldowns: Dictionary = {
	"skill_1": 5.0,
	"skill_2": 4.0,
	"skill_3": 6.0,
	"skill_4": 3.0,
	"skill_5": 15.0,
}

# Passives
var passives: Array = []
var kill_streak: int = 0
var kill_streak_timer: float = 0.0
var last_hit_time: float = 0.0

# Combo damage
var combo_damages: Array = [20, 25, 30]

func _ready():
	hp = max_hp
	stamina = max_stamina

	# Connect hitbox signals
	var hitbox = $Hitbox
	if hitbox:
		hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta: float):
	if game_state != STATE_PLAYING:
		velocity = Vector2.ZERO
		return

	_handle_movement(delta)
	_handle_combat(delta)
	_handle_dodge(delta)
	_handle_stamina(delta)
	_handle_invulnerability(delta)
	_handle_passives(delta)

	move_and_slide()

func _handle_movement(delta: float) -> void:
	if is_dodging:
		return

	var move_input = Global.joystick_input
	if move_input.length() > joystick_dead_zone:
		velocity = move_input * move_speed
		facing_direction = move_input.normalized()
		# Flip sprite
		if move_input.x < 0:
			$Sprite2D.flip_h = true
		elif move_input.x > 0:
			$Sprite2D.flip_h = false
	else:
		velocity = Vector2.ZERO

func _handle_combat(delta: float) -> void:
	combo_timer -= delta
	if combo_timer <= 0 and combo_count > 0:
		combo_count = 0

func _handle_dodge(delta: float) -> void:
	dodge_cooldown_timer -= delta

	if is_dodging:
		dodge_timer -= delta
		if dodge_timer <= 0:
			is_dodging = false

	if is_invulnerable:
		invulnerability_timer -= delta
		if invulnerability_timer <= 0:
			is_invulnerable = false
			modulate = Color(1, 1, 1, 1)

func _handle_stamina(delta: float) -> void:
	if not is_dodging:
		stamina = min(max_stamina, stamina + stamina_regen_rate * delta)
		emit_signal("stamina_changed", int(stamina), max_stamina)

func _handle_passives(delta: float) -> void:
	kill_streak_timer -= delta
	if kill_streak_timer <= 0:
		kill_streak = 0

func take_damage(amount: int) -> void:
	if is_invulnerable or game_state != STATE_PLAYING:
		return

	# Apply damage reduction from passive
	if "iron_wall" in passives:
		amount = int(amount * 0.9)

	hp -= amount
	emit_signal("health_changed", hp, max_hp)

	if hp <= 0:
		hp = 0
		game_state = STATE_DEAD
		emit_signal("died")
	elif hp <= max_hp * 0.5 and "blood_rage" in passives:
		# Blood rage passive: +20% damage when HP < 50%
		pass

func heal(amount: int) -> void:
	hp = min(max_hp, hp + amount)
	emit_signal("health_changed", hp, max_hp)

func attack() -> Dictionary:
	if is_dodging or game_state != STATE_PLAYING:
		return {}

	if combo_timer > 0 and combo_count >= 3:
		combo_count = 0

	combo_count += 1
	combo_timer = COMBO_WINDOW

	var damage = combo_damages[combo_count - 1]
	if "blood_rage" in passives and hp < max_hp * 0.5:
		damage = int(damage * 1.2)

	var attack_speed_mult = 1.0
	if "chain_strike" in passives:
		attack_speed_mult += min(0.3, kill_streak * 0.1)

	emit_signal("combo_hit", combo_count)

	return {
		"damage": damage,
		"knockback": 50.0 if combo_count < 3 else 100.0,
		"hit_number": combo_count,
		"speed_mult": attack_speed_mult,
	}

func dodge() -> bool:
	if game_state != STATE_PLAYING:
		return false
	if is_dodging:
		return false
	if dodge_cooldown_timer > 0:
		return false
	if stamina < DODGE_COST:
		return false

	stamina -= DODGE_COST
	emit_signal("stamina_changed", int(stamina), max_stamina)

	is_dodging = true
	dodge_timer = DODGE_DURATION
	dodge_cooldown_timer = DODGE_COOLDOWN
	is_invulnerable = true
	invulnerability_timer = IFRAMES_DURATION

	# Move in facing direction
	velocity = facing_direction * move_speed * 3.0

	modulate = Color(1, 1, 1, 0.5)

	return true

func use_skill(skill_id: String) -> bool:
	if game_state != STATE_PLAYING:
		return false
	if skill_cooldowns[skill_id] > 0:
		return false

	match skill_id:
		"skill_1":  # 剑气斩 - Melee AOE
			skill_cooldowns[skill_id] = skill_max_cooldowns[skill_id]
			emit_signal("skill_used", skill_id)
			return true
		"skill_2":  # 飞燕回翔 - Dash Attack
			skill_cooldowns[skill_id] = skill_max_cooldowns[skill_id]
			emit_signal("skill_used", skill_id)
			return true
		"skill_3":  # 冰魄掌 - Ice Projectile
			skill_cooldowns[skill_id] = skill_max_cooldowns[skill_id]
			emit_signal("skill_used", skill_id)
			return true
		"skill_4":  # 御风步 - Blink
			skill_cooldowns[skill_id] = skill_max_cooldowns[skill_id]
			emit_signal("skill_used", skill_id)
			return true
		"skill_5":  # 破军 - Screen Nuke
			skill_cooldowns[skill_id] = skill_max_cooldowns[skill_id]
			emit_signal("skill_used", skill_id)
			return true
	return false

func _process(delta: float):
	# Update skill cooldowns
	for skill in skill_cooldowns:
		if skill_cooldowns[skill] > 0:
			skill_cooldowns[skill] -= delta

func on_enemy_killed():
	kill_streak += 1
	kill_streak_timer = 3.0

	# Lifesteal passive
	if "lifesteal" in passives:
		var heal_amount = int(combo_damages[min(combo_count - 1, 2)] * 0.05)
		heal(heal_amount)

func add_passive(passive_id: String) -> bool:
	if passives.size() >= 3:
		return false
	if passive_id in passives:
		return false

	passives.append(passive_id)

	match passive_id:
		"swift_wind":
			move_speed *= 1.15

	return true

func set_game_state(new_state: int) -> void:
	game_state = new_state
	if new_state == STATE_PLAYING:
		modulate = Color(1, 1, 1, 1)
	elif new_state == STATE_DEAD or new_state == STATE_VICTORY:
		velocity = Vector2.ZERO

func reset_stats():
	hp = max_hp
	stamina = max_stamina
	combo_count = 0
	combo_timer = 0.0
	is_dodging = false
	is_invulnerable = false
	passives.clear()
	move_speed = 200.0
	kill_streak = 0
	kill_streak_timer = 0.0

	for skill in skill_cooldowns:
		skill_cooldowns[skill] = 0.0

	emit_signal("health_changed", hp, max_hp)
	emit_signal("stamina_changed", int(stamina), max_stamina)

signal skill_used(skill_id: String)

func _on_hitbox_body_entered(body: Node) -> void:
	# This is called when the player's attack hitbox touches something
	pass
