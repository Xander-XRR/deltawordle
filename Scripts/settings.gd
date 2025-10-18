@tool
extends DeltaWindow
class_name SettingsWindows

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_save: AudioStreamPlayer = $AudioStreamPlayerSave
@onready var alt_soul: TextureRect = $AltSoul

const MAIN = preload("res://Scenes/main.tscn")
const ALT_MAIN = preload("res://Scenes/alt_main.tscn")


func _ready() -> void:
	super()
	close_requested.connect(_on_close_requested)
	
	if Settings.encountered_experiment:
		alt_soul.visible = true
	


func _on_close_requested() -> void:
	Settings.save_settings()
	audio_stream_player_save.play()
	


func _on_alt_soul_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("left_mouse_button"):
		SceneTransition.set_vertical_bars(400.0)
		window_hide()
		await get_tree().create_timer(0.25).timeout
		
		match get_tree().current_scene.name:
			"Main":
				get_tree().call_deferred("change_scene_to_packed", ALT_MAIN)
				await get_tree().scene_changed
			"alt_main":
				get_tree().call_deferred("change_scene_to_packed", MAIN)
				await get_tree().scene_changed
			_:
				get_tree().call_deferred("change_scene_to_packed", MAIN)
				await get_tree().scene_changed
		
		SceneTransition.set_vertical_bars(0.0)
	
