extends Node2D

## Main game scene - handles room management and game state.

signal room_cleared(room_index: int)
signal boss_spawned

@export var room_scene_path: String = "res://rooms/room.tscn"

var current_room_index: int = 0
var room_order: Array = []
var current_room_node: Node2D = null

# Room config
const NUM_NORMAL_ROOMS: int = 3
const TOTAL_ROOMS: int = 4  # 3 normal + 1 boss

var screen_shake_intensity: float = 0.0
var screen_shake_duration: float = 0.0

func _ready():
	Global.current_state = Global.GameState.PLAYING
	_generate_room_order()
	_spawn_room(current_room_index)

func _generate_room_order() -> void:
	room_order.clear()
	# Generate 3 random room indices (0-2), then add boss (3)
	var room_indices = [0, 1, 2]
	room_indices.shuffle()
	room_order = room_indices
	room_order.append(3)  # Boss room is always last

func _spawn_room(index: int) -> void:
	# Remove previous room
	if current_room_node:
		current_room_node.queue_free()

	var room_type = room_order[index]
	var room_path = "res://rooms/room_%d.tscn" % room_type

	var packed_scene = load(room_path)
	if packed_scene:
		current_room_node = packed_scene.instantiate()
	else:
		# Create a default room if specific room scene doesn't exist
		current_room_node = _create_default_room(room_type)

	current_room_node.room_cleared.connect(_on_room_cleared)
	add_child(current_room_node)

	# Spawn player in current room if first room
	if index == 0 and not has_node("Player"):
		_spawn_player()

	# Spawn enemies based on room type
	_spawn_enemies_for_room(room_type)

func _create_default_room(room_type: int) -> Node2D:
	var room = Node2D.new()
	room.set_script(load("res://rooms/room.gd"))

	# Add a floor
	var floor = ColorRect.new()
	floor.color = Color(0.1, 0.1, 0.15, 1)
	floor.size = Vector2(800, 600)
	floor.position = Vector2(-400, -300)
	room.add_child(floor)

	return room

func _spawn_player() -> void:
	var player_scene = load("res://player.tscn")
	var player = player_scene.instantiate()
	player.position = Vector2(0, 100)
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)
	add_child(player)
	Global.player_node = player

func _spawn_enemies_for_room(room_type: int) -> void:
	match room_type:
		0, 1, 2:  # Normal rooms
			_spawn_normal_room_enemies(2 + room_type)
		3:  # Boss room
			_spawn_boss()

func _spawn_normal_room_enemies(count: int) -> void:
	var melee_scene = load("res://enemies/melee_enemy.tscn")
	for i in range(count):
		var enemy = melee_scene.instantiate()
		enemy.position = Vector2(randf_range(-200, 200), randf_range(-100, -200))
		enemy.player_ref = get_node_or_null("Player")
		add_child(enemy)

func _spawn_boss() -> void:
	var boss_scene = load("res://enemies/boss.tscn")
	var boss = boss_scene.instantiate()
	boss.position = Vector2(0, -150)
	boss.player_ref = get_node_or_null("Player")
	boss.died.connect(_on_boss_died)
	add_child(boss)
	emit_signal("boss_spawned")

func _on_room_cleared(room_index: int) -> void:
	emit_signal("room_cleared", room_index)
	Global.clear_room(room_index)

	# Move to next room
	if room_index < TOTAL_ROOMS - 1:
		current_room_index += 1
		_spawn_room(current_room_index)

func _on_player_health_changed(current: int, max_val: int) -> void:
	if current <= 0:
		_on_player_died()

func _on_player_died() -> void:
	Global.current_state = Global.GameState.DEAD
	_show_death_screen()

func _on_boss_died() -> void:
	Global.current_state = Global.GameState.VICTORY
	_show_victory_screen()

func _show_death_screen() -> void:
	if has_node("DeathScreen"):
		return
	var death_screen = load("res://ui/death_screen.tscn").instantiate()
	add_child(death_screen)

func _show_victory_screen() -> void:
	if has_node("VictoryScreen"):
		return
	var victory_screen = load("res://ui/victory_screen.tscn").instantiate()
	add_child(victory_screen)

func _process(delta: float):
	# Screen shake
	if screen_shake_duration > 0:
		screen_shake_duration -= delta
		var camera = get_node_or_null("Player/Camera2D")
		if camera:
			var offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * screen_shake_intensity
			camera.offset = offset

func camera_shake(intensity: float = 5.0, duration: float = 0.2) -> void:
	screen_shake_intensity = intensity
	screen_shake_duration = duration

func _input(event: InputEvent):
	if event.is_action_pressed("return_to_main_menu"):
		get_tree().change_scene_to_file("res://main_menu.tscn")
