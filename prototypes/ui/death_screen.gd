extends CanvasLayer

## Death screen overlay shown when player HP reaches 0.

func _ready():
	$VBoxContainer/RetryButton.grab_focus()

func _on_retry_button_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://game.tscn")

func _on_menu_button_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://main_menu.tscn")
