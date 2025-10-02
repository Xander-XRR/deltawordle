@tool
extends DeltaWindow
class_name SettingsWindows

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_save: AudioStreamPlayer = $AudioStreamPlayerSave
@onready var alt_soul: TextureRect = $AltSoul

var soul: Soul

func _ready() -> void:
	super()
	close_requested.connect(_on_close_requested)
	
	soul = get_tree().current_scene.get_node("Soul")
	if !soul:
		push_error("No Soul Node Found.")
	
	if Settings.encountered_experiment:
		alt_soul.visible = true
	


func _on_close_requested() -> void:
	Settings.save_settings()
	audio_stream_player_save.play()
	


func _on_alt_soul_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("left_mouse_button"):
		SceneTransition.animate_vertical_bars(400.0, 0.01)
		await get_tree().create_timer(0.1).timeout
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/alt_main.tscn")
