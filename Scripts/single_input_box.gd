extends Control


@onready var line_edit: LineEdit = $LineEdit
@onready var parent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var anim_line_edit: LineEdit = $SubViewport/AnimLineEdit

@export var word_lenght: int = 5
var index: int

signal added_letter(index: int, letter: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	index = get_index()
	parent = get_parent()
	
	if index == 0:
		line_edit.call_deferred("grab_focus")
	


func play_submit_animation() -> void:
	line_edit.visible = false
	anim_line_edit.text = line_edit.text
	animation_player.play("flip")
	line_edit.visible = true
	


func _focus_new_input(idx: int) -> void:
	line_edit.call_deferred("release_focus")
	await get_tree().process_frame
	var new_input = parent.get_child(idx)
	new_input.line_edit.call_deferred("grab_focus")
	


func _on_line_edit_text_changed(new_text: String) -> void:
	added_letter.emit(index, new_text)
	line_edit.editable = false
	
	if !index == word_lenght - 1:
		_focus_new_input(index + 1)
		return
	


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("backspace") and line_edit.has_focus():
		print("B")
		if index == 0:
			added_letter.emit(index, "")
			return
		
		if index == word_lenght - 1:
			if line_edit.text != "":
				added_letter.emit(index, "")
				return
		
		parent.get_child(index - 1).line_edit.editable = true
		parent.get_child(index - 1).line_edit.text = ""
		_focus_new_input(index - 1)
		added_letter.emit(index - 1, "")
		return
