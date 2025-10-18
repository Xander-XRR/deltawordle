extends Node2D

var MAIN: PackedScene
var ALT_MAIN: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MAIN = ResourceLoader.load("res://Scenes/main.tscn") as PackedScene
	ALT_MAIN = ResourceLoader.load("res://Scenes/alt_main.tscn") as PackedScene
	
	SceneTransition.set_vertical_bars(400.0)
	
	var cmd_args: Array = OS.get_cmdline_args()
	var fun = randi() % 100 + 1
	
	var arg: String = cmd_args[0]
	if arg.begins_with("--fun"):
		fun = int(arg.split("=")[1])
	elif arg.begins_with("--netz"):
		fun = 56
	elif arg.begins_with("--gaster"):
		fun = 66
	
	print("Loader: FUN value: ", fun)
	
	# netz!! third sanctuary custom intro
	if fun == 56:
		Global.custom_intro = Global.CustomIntros.CHURCH3_REMIX
		get_tree().call_deferred("change_scene_to_packed", MAIN)
	
	# chapter 1 themed black-green menu thingymagib
	elif fun == 66:
		get_tree().call_deferred("change_scene_to_packed", ALT_MAIN)
	
	# main game 
	else:
		SceneTransition.transition_to_scene(MAIN, 0.01)
