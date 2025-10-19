## Stores Globally accessable variables and functions.
extends Node


enum CustomIntros { NONE, CHURCH3_REMIX }

var word_size: int = 5
var custom_intro: int


func open_and_show_file(res_path: String, out_name: String) -> void:
	var file = FileAccess.open(res_path, FileAccess.READ)
	if file == null:
		push_error("Global: Failed to open File: ", res_path)
		return
	var data = file.get_buffer(file.get_length())
	file.close()
	
	var out_path = "user://" + out_name
	var user_file = FileAccess.open(out_path, FileAccess.WRITE)
	if user_file == null:
		push_error("Global: Failed to write to user:// Folder")
		return
	user_file.store_buffer(data)
	user_file.close()
	
	var abs_path = ProjectSettings.globalize_path(out_path)
	OS.shell_open(abs_path)
