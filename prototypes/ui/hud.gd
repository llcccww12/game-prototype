extends CanvasLayer

## HUD layer showing health, stamina, room progress, and passive icons.

signal attack_pressed
signal dodge_pressed
signal skill_1_pressed
signal skill_2_pressed
signal skill_3_pressed
signal skill_4_pressed
signal skill_5_pressed

@onready var health_bar: ProgressBar = $TopBar/HealthBar
@onready var stamina_bar: ProgressBar = $TopBar/StaminaBar
@onready var room_dots: HBoxContainer = $TopBar/RoomProgress

var max_rooms: int = 4

func _ready():
	_update_health_bar(100, 100)
	_update_stamina_bar(100, 100)

func _update_health_bar(current: int, max_val: int) -> void:
	health_bar.max_value = max_val
	health_bar.value = current

	# Change color based on percentage
	var ratio = float(current) / max_val
	if ratio > 0.5:
		health_bar.modulate = Color.GREEN
	elif ratio > 0.25:
		health_bar.modulate = Color.YELLOW
	else:
		health_bar.modulate = Color.RED

func _update_stamina_bar(current: int, max_val: int) -> void:
	stamina_bar.max_value = max_val
	stamina_bar.value = current

func update_room_progress(cleared_rooms: Array) -> void:
	for i in range(room_dots.get_child_count()):
		var dot = room_dots.get_child(i)
		if i in cleared_rooms:
			dot.modulate = Color.GREEN
		else:
			dot.modulate = Color.WHITE

func update_passive_icons(passives: Array) -> void:
	for i in range(min(3, $Passives.get_child_count())):
		var icon = $Passives.get_child(i)
		if i < passives.size():
			icon.visible = true
			# Set icon based on passive type
			match passives[i]:
				"blood_rage":
					icon.get_node("Label").text = "血"
				"iron_wall":
					icon.get_node("Label").text = "铁"
				"chain_strike":
					icon.get_node("Label").text = "连"
				"lifesteal":
					icon.get_node("Label").text = "吸"
				"swift_wind":
					icon.get_node("Label").text = "风"
		else:
			icon.visible = false

func update_skill_cooldowns(cooldowns: Dictionary, max_cooldowns: Dictionary) -> void:
	_update_skill_cooldown($SkillBar/Skill1, cooldowns.get("skill_1", 0), max_cooldowns.get("skill_1", 5))
	_update_skill_cooldown($SkillBar/Skill2, cooldowns.get("skill_2", 0), max_cooldowns.get("skill_2", 4))
	_update_skill_cooldown($SkillBar/Skill3, cooldowns.get("skill_3", 0), max_cooldowns.get("skill_3", 6))
	_update_skill_cooldown($SkillBar/Skill4, cooldowns.get("skill_4", 0), max_cooldowns.get("skill_4", 3))
	_update_skill_cooldown($SkillBar/Skill5, cooldowns.get("skill_5", 0), max_cooldowns.get("skill_5", 15))

func _update_skill_cooldown(button: Button, current: float, max_val: float) -> void:
	if current > 0:
		button.disabled = true
		button.get_node("CooldownLabel").text = "%.1f" % current
		button.get_node("CooldownLabel").visible = true
	else:
		button.disabled = false
		button.get_node("CooldownLabel").visible = false

func _on_attack_button_pressed():
	emit_signal("attack_pressed")

func _on_dodge_button_pressed():
	emit_signal("dodge_pressed")

func _on_skill_1_pressed():
	emit_signal("skill_1_pressed")

func _on_skill_2_pressed():
	emit_signal("skill_2_pressed")

func _on_skill_3_pressed():
	emit_signal("skill_3_pressed")

func _on_skill_4_pressed():
	emit_signal("skill_4_pressed")

func _on_skill_5_pressed():
	emit_signal("skill_5_pressed")

func show_damage_number(position: Vector2, damage: int) -> void:
	var label = Label.new()
	label.text = str(damage)
	label.position = position
	label.modulate = Color.RED
	add_child(label)

	# Animate floating up and fading
	var tween = create_tween()
	label.position.y -= 30
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)
