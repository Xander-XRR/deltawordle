@tool
extends Panel
## A custom Window Class.
class_name DeltaWindow


var title_label: Label
var quit_button: Button
var body_title_seperator: HSeparator
var drag_control: Control

var _window_title: String
@export var window_title: String:
	set(v):
		_window_title = v
		if Engine.is_editor_hint():
			_create_window_gizmos_if_missing()
		if title_label:
			title_label.text = v
	get():
		return _window_title

const DELTARUNE_CLOSE_BUTTON_STYLE_HOVERED = preload("uid://boe2nk1qgyai3")
const DELTARUNE_CLOSE_BUTTON_STYLE_NORMAL = preload("uid://tvhujlkqqybi")
const DELTARUNE_CLOSE_BUTTON_STYLE_PRESSED = preload("uid://6iafa18xitft")

signal close_requested

var _is_being_dragged: bool = false
var _dragging_offset: Vector2 = Vector2.ZERO

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		custom_minimum_size = Vector2(300.0, 100.0)
	
	_create_window_gizmos_if_missing()


func _create_window_gizmos_if_missing():
	if has_node("TitleLabel"):
		title_label = get_node("TitleLabel")
	else:
		var label = Label.new()
		label.name = "TitleLabel"
		label.text = "Default Title"
		label.size.x = size.x
		label.position.y = 12.0
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 31)
		
		add_child(label)
		title_label = label
		label.owner = owner
		title_label.text = _window_title
	
	if has_node("QuitButton"):
		quit_button = get_node("QuitButton")
	else:
		var button = Button.new()
		button.name = "QuitButton"
		button.add_theme_stylebox_override("normal", DELTARUNE_CLOSE_BUTTON_STYLE_NORMAL)
		button.add_theme_stylebox_override("pressed", DELTARUNE_CLOSE_BUTTON_STYLE_PRESSED)
		button.add_theme_stylebox_override("hover", DELTARUNE_CLOSE_BUTTON_STYLE_HOVERED)
		button.add_theme_stylebox_override("hover_pressed", DELTARUNE_CLOSE_BUTTON_STYLE_PRESSED)
		button.call_deferred("set", "size", Vector2(56.0, 56.0))
		button.position.x = size.x - 72.0
		button.position.y = 16.0
		
		add_child(button)
		quit_button = button
		quit_button.owner = owner
	
	if has_node("BodyTitleSeperator"):
		body_title_seperator = get_node("BodyTitleSeperator")
	else:
		var sep = HSeparator.new()
		sep.name = "BodyTitleSeperator"
		sep.position = Vector2(24.0, 70.0)
		sep.size.x = size.x - 48.0
		
		add_child(sep)
		body_title_seperator = sep
		sep.owner = owner
	
	if has_node("DragControl"):
		drag_control = get_node("DragControl")
	else:
		var ctrl = Control.new()
		ctrl.name = "DragControl"
		ctrl.size = Vector2(size.x - 88.0, 56)
		ctrl.position = Vector2(16.0, 16.0)
		
		add_child(ctrl)
		drag_control = ctrl
		ctrl.owner = owner
	


func _ready() -> void:
	if not title_label and has_node("TitleLabel"):
		title_label = get_node("TitleLabel")
	if not quit_button and has_node("QuitButton"):
		quit_button = get_node("QuitButton")
	if not body_title_seperator and has_node("BodyTitleSeperator"):
		body_title_seperator = get_node("BodyTitleSeperator")
	if not drag_control and has_node("DragControl"):
		drag_control = get_node("DragControl")
	
	if quit_button:
		quit_button.pressed.connect(func(): close_requested.emit())
	if drag_control:
		drag_control.gui_input.connect(_on_drag_control_gui_input)
	
	if !visible:
		window_hide()
	


func window_popup(centered: bool = false) -> void:
	var tween = create_tween()
	if centered:
		global_position = get_viewport_rect().size * 0.5 - size * scale * 0.5
	scale = Vector2(0.9, 0.9)
	modulate = Color.TRANSPARENT
	
	visible = true
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
	tween.parallel().tween_property(self, "global_position", global_position - size * Vector2(0.05, 0.05), 0.1)
	tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.1)
	


func window_hide() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.1)
	tween.parallel().tween_property(self, "global_position", global_position + size * Vector2(0.05, 0.05), 0.1)
	await tween.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 0.1).finished
	visible = false
	


func _process(_delta: float) -> void:
	if _is_being_dragged:
		var target_global := get_global_mouse_position() - _dragging_offset
		
		var bound_size = get_viewport().get_visible_rect().size
		target_global.x = clamp(target_global.x, 0.0, max(0.0, bound_size.x - drag_control.size.x))
		target_global.y = clamp(target_global.y, 0.0, max(0.0, bound_size.y - drag_control.size.y))
		
		global_position = target_global


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		if title_label:
			title_label.size.x = size.x
		if quit_button:
			quit_button.position.x = size.x - 72.0
		if body_title_seperator:
			body_title_seperator.size.x = size.x - 48.0
		if drag_control:
			drag_control.size.x = size.x - 88.0
	


func _on_drag_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_is_being_dragged = true
			_dragging_offset = get_global_mouse_position() - global_position
		else:
			_is_being_dragged = false
	
