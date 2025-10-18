@tool
extends DeltaWindow

@onready var music_select: OptionButton = $MusicLabelPanel/MusicSelect


func _ready() -> void:
	super()
	Settings.settings_window_hide_requested.connect(_on_settings_close_request)


func _on_title_button_pressed() -> void:
	SceneTransition.transition_to_scene("res://Scenes/main.tscn")


func _on_settings_button_pressed() -> void:
	window_interactable(MouseFilter.MOUSE_FILTER_STOP)
	Settings.show_settings_window()


func _on_settings_close_request() -> void:
	window_interactable(MouseFilter.MOUSE_FILTER_IGNORE)
	Settings.hide_settings_window()
