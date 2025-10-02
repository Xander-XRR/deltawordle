extends Panel


@onready var letter_label: Label = $LetterLabel

@export var displayed_letter: String
@export var is_interactable: bool = false
@export var is_control_char: bool = false

const DELTARUNE_OPTION_STYLE = preload("uid://bd1clh85su2yv")
const DELTARUNE_OPTION_SELECTED_STYLE = preload("uid://bww75ndrxdm03")

signal pressed(string: String)

func _ready() -> void:
	letter_label.text = displayed_letter
	


func selected() -> void:
	add_theme_stylebox_override("panel", DELTARUNE_OPTION_SELECTED_STYLE)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		if is_interactable:
			print(name, " responded with String: ", letter_label.text)
			pressed.emit(letter_label.text)
