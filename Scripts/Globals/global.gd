## Stores Globally accessable variables and functions.
extends Node


enum CustomIntros { NONE, CHURCH3_REMIX }

var word_size: int = 5
var custom_intro: int


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_F4:
		var fullscreen_state = Settings.settings_window.fullscreen_check_box.button_pressed
		Settings.settings_window.fullscreen_check_box.button_pressed = !fullscreen_state
