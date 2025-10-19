@tool
extends DeltaWindow
class_name SettingsWindows


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_save: AudioStreamPlayer = $AudioStreamPlayerSave
@onready var alt_soul: TextureRect = $AltSoul
@onready var fullscreen_check_box: CheckBox = $TabContainer/GENERAL/List/Fullscreen/FullscreenCheckBox
@onready var silly_bugs_confirmation: ConfirmationDialog = $TabContainer/GENERAL/List/SillyBugs/SillyBugsConfirmation
@onready var silly_bugs_check_box: CheckBox = $TabContainer/GENERAL/List/SillyBugs/SillyBugsCheckBox

const MAIN = preload("res://Scenes/main.tscn")
const ALT_MAIN = preload("res://Scenes/alt_main.tscn")


func _ready() -> void:
	super()
	close_requested.connect(_on_close_requested)
	
	if Settings.encountered_experiment:
		alt_soul.visible = true
	fullscreen_check_box.button_pressed = Settings.fullscreen
	silly_bugs_check_box.button_pressed = Settings.enable_silly_bugs
	


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
	


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	var mode = DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)
	Settings.fullscreen = toggled_on
	print("Window Mode: ", mode)
	print("Fullscreen: ", toggled_on)
	


func _on_silly_bugs_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on and Settings.knows_silly_bugs_dangers == false:
		silly_bugs_confirmation.popup_centered()
		window_interactable(MouseFilter.MOUSE_FILTER_STOP)
	else:
		Settings.enable_silly_bugs = true


func _on_silly_bugs_confirmation_canceled() -> void:
	silly_bugs_check_box.button_pressed = false
	window_interactable(MouseFilter.MOUSE_FILTER_IGNORE)
	silly_bugs_confirmation.hide()


func _on_silly_bugs_confirmation_confirmed() -> void:
	Settings.knows_silly_bugs_dangers = true
	Settings.enable_silly_bugs = true
	Settings.save_settings()
	silly_bugs_confirmation.hide()
	window_interactable(MouseFilter.MOUSE_FILTER_IGNORE)
