extends CanvasLayer

## Game UI layer that connects HUD input to player actions.

var player: Node = null

func _ready():
	# Get player reference
	player = get_node_or_null("/root/Game/Player")

	# Connect HUD signals
	var hud = $HUD
	if hud:
		hud.attack_pressed.connect(_on_attack_pressed)
		hud.dodge_pressed.connect(_on_dodge_pressed)
		hud.skill_1_pressed.connect(_on_skill_1)
		hud.skill_2_pressed.connect(_on_skill_2)
		hud.skill_3_pressed.connect(_on_skill_3)
		hud.skill_4_pressed.connect(_on_skill_4)
		hud.skill_5_pressed.connect(_on_skill_5)

func _on_attack_pressed():
	if player:
		player.attack()

func _on_dodge_pressed():
	if player:
		player.dodge()

func _on_skill_1():
	if player:
		player.use_skill("skill_1")

func _on_skill_2():
	if player:
		player.use_skill("skill_2")

func _on_skill_3():
	if player:
		player.use_skill("skill_3")

func _on_skill_4():
	if player:
		player.use_skill("skill_4")

func _on_skill_5():
	if player:
		player.use_skill("skill_5")
