extends CanvasLayer


func _ready() -> void:
	for scene in DirAccess.get_files_at(ProjectSettings.globalize_path("res://Scenes/")):
		$GotToScene.add_item(scene)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if Input.is_key_pressed(KEY_F3) and Input.is_key_pressed(KEY_F4):
			visible = !visible


func _on_open_settings_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path(Settings.SAVE_PATH))


func _on_delete_settings_pressed() -> void:
	print(ProjectSettings.globalize_path(Settings.SAVE_PATH))
	if FileAccess.file_exists(ProjectSettings.globalize_path(Settings.SAVE_PATH)):
		var err = OS.move_to_trash(ProjectSettings.globalize_path(Settings.SAVE_PATH))
		if err != OK:
			print("Unsuccessfull Removal: ", err)


func _on_got_to_scene_button_pressed() -> void:
	if $GotToScene.selected != -1:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/" + $GotToScene.get_item_text($GotToScene.selected))
