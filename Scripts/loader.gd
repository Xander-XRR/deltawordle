extends Node2D

const MAIN = preload("uid://b6d0x2ax8xwx3")
const ALT_MAIN = preload("uid://18g316md6k3t")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.animate_vertical_bars(400.0, 0.01)
	var fun = randi() % 100 + 1
	if fun != 66:
		SceneTransition.animate_vertical_bars(0.0, 1.0)
		get_tree().call_deferred("change_scene_to_packed", MAIN)
	else:
		get_tree().call_deferred("change_scene_to_packed", ALT_MAIN)
