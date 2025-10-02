extends RichTextLabel
class_name RichTextButton


@onready var sfx_player_noise: AudioStreamPlayer = $"../SFXPlayerNoise"
@onready var sfx_player_select: AudioStreamPlayer = $"../SFXPlayerSelect"
@export var cursor: String = "> "

signal hovered
signal unhovered
signal pressed


func _init() -> void:
	focus_entered.connect(_selected)
	mouse_entered.connect(_selected)
	focus_exited.connect(_unselected)
	mouse_exited.connect(_unselected)
	hovered.connect(_on_hovered)
	unhovered.connect(_on_unhovered)
	pressed.connect(_on_pressed)
	


func _selected():
	hovered.emit()

func _unselected():
	unhovered.emit()


func _on_hovered() -> void:
	text = cursor + text
	sfx_player_noise.play()
	

func _on_unhovered() -> void:
	text = text.trim_prefix(cursor)
	

func _on_pressed() -> void:
	sfx_player_select.play()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("left_mouse_button"):
		pressed.emit()
	
