extends Node2D

func _ready():
	$CanvasLayer/VBoxContainer/StartButton.grab_focus()

	if not OS.has_feature("pc"):
		$CanvasLayer/VBoxContainer/FullscreenButton.hide()
		$CanvasLayer/VBoxContainer/QuitButton.hide()

func _on_start_button_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://game.tscn")

func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_quit_button_pressed():
	get_tree().quit()
