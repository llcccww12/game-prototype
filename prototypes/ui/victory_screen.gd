extends CanvasLayer

## Victory screen shown when boss is defeated.

func _ready():
	$VBoxContainer/PlayAgainButton.grab_focus()

func _on_play_again_button_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://game.tscn")

func _on_menu_button_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://main_menu.tscn")
