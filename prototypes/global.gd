extends Node

## Global game state and shared data.

signal joystick_input_changed(vector: Vector2)

# Game state
enum GameState { MENU, PLAYING, PAUSED, DEAD, VICTORY }

var current_state: GameState = GameState.MENU
var joystick_input: Vector2 = Vector2.ZERO

# Room state
var current_room: int = 0
var total_rooms: int = 4
var rooms_cleared: Array = []

# Player stats reference (set by player node)
var player_node: Node = null

# Skill unlock state
var unlocked_skills: Array = []

func _ready():
	pass

func set_state(new_state: GameState) -> void:
	current_state = new_state

func get_state() -> GameState:
	return current_state

func update_joystick_input(vector: Vector2) -> void:
	joystick_input = vector
	emit_signal("joystick_input_changed", vector)

func clear_room(index: int) -> void:
	if index not in rooms_cleared:
		rooms_cleared.append(index)

func is_room_cleared(index: int) -> bool:
	return index in rooms_cleared

func reset_game() -> void:
	current_room = 0
	rooms_cleared.clear()
	current_state = GameState.MENU
