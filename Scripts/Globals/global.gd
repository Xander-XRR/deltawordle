## Stores Globally accessable variables and functions.
extends Node


enum CustomIntros { CHURCH3_REMIX = 1 }

var word_size: int = 5
var custom_intro: int


func open_and_show_file(res_path: String, out_name: String) -> void:
	var r = FileAccess.open(res_path, FileAccess.READ)
	if r == null:
		push_error("Failed to open File: ", res_path)
		return
	var data = r.get_buffer(r.get_length())
	r.close()
	
	var out_path = "user://" + out_name
	var w = FileAccess.open(out_path, FileAccess.WRITE)
	if w == null:
		push_error("Failed to write to user:// Folder")
		return
	w.store_buffer(data)
	w.close()
	
	# convert to absolute path then open externally
	var abs_path = ProjectSettings.globalize_path(out_path)
	OS.shell_open(abs_path)
