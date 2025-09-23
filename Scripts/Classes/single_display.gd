extends Control
class_name SingleDisplay


@onready var label: RichTextLabel = $Label
@onready var panel: Panel = $Panel

@export var initial_letter: String
@export var control_character: bool = false

const DELTARUNE_OPTION_STYLE = preload("res://Assets/Styles/deltarune_option_style.tres")
const DELTARUNE_OPTION_SELECTED_STYLE = preload("res://Assets/Styles/deltarune_option_selected_style.tres")

func _ready() -> void:
	panel.add_theme_stylebox_override("panel", DELTARUNE_OPTION_STYLE)
	
	if initial_letter:
		label.text = initial_letter
	
	if control_character:
		custom_minimum_size.x *= 2
		update_minimum_size()
		size.x *= 2
		panel.size.x *= 2
		label.size.x *= 2
		
		var control = $SoulMagnet
		if control:
			control.size.x *= 2
		
	


func set_theme_style(sel: bool = true) -> void:
	if sel:
		panel.add_theme_stylebox_override("panel", DELTARUNE_OPTION_SELECTED_STYLE)
	else:
		panel.add_theme_stylebox_override("panel", DELTARUNE_OPTION_STYLE)


func selected() -> void:
	set_theme_style()
