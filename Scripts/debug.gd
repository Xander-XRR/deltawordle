extends CanvasLayer


func _ready() -> void:
	for scene in DirAccess.get_files_at("res://Scenes/"):
		$GotToScene.add_item(scene)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if Input.is_key_pressed(KEY_F3):
			visible = !visible


func _on_open_settings_pressed() -> void:
	print("DEBUG: Settings Path: ", ProjectSettings.globalize_path(Settings.SAVE_PATH))
	OS.shell_open(ProjectSettings.globalize_path(Settings.SAVE_PATH))
	


func _on_delete_settings_pressed() -> void:
	print("DEBUG: Settings Path: ", ProjectSettings.globalize_path(Settings.SAVE_PATH))
	if FileAccess.file_exists(ProjectSettings.globalize_path(Settings.SAVE_PATH)):
		var err = OS.move_to_trash(ProjectSettings.globalize_path(Settings.SAVE_PATH))
		if err != OK:
			print("DEBUG: Unsuccessful Settings Removal: ", err)


func _on_got_to_scene_button_pressed() -> void:
	if $GotToScene.selected != -1:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/" + $GotToScene.get_item_text($GotToScene.selected))


func _on_hide_windows_pressed() -> void:
	Settings.hide_settings_window()
	for window in DeltaWindowsLayer.get_children():
		if window is DeltaWindow:
			window.window_hide()
