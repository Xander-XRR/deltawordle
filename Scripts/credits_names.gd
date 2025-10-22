extends Node2D


var names_list: Array = []
var selected: RichTextCredit
var offset: Vector2 = Vector2(30.0, 70.0)

signal new_selected(index: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_init_pos()
	


func set_init_pos() -> void:
	selected = get_child(0)
	selected.scale = Vector2(1.5, 1.5)
	selected.modulate = Color.YELLOW
	for n: RichTextCredit in get_children():
		n.position = (offset * n.get_index()) - (selected.get_index() * offset)
	


func scroll_by(dir: int) -> void:
	var new_selected_index = selected.get_index() + dir
	if new_selected_index <= -1 or new_selected_index >= get_children().size():
		return
	
	selected = get_child(new_selected_index)
	
	for n: RichTextCredit in get_children():
		var new_pos = n.global_position - offset * dir
		create_tween().tween_property(n, "global_position", new_pos, 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	var old_selected: RichTextCredit = get_child(new_selected_index - dir)
	
	old_selected.modulate = Color.WHITE
	selected.modulate = Color.YELLOW
	
	var scale_tween = create_tween()
	scale_tween.tween_property(old_selected, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	scale_tween.parallel().tween_property(selected, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	new_selected.emit(new_selected_index)
	


func _input(event: InputEvent) -> void:
	if (event.is_action("up") or event.is_action("scroll_up")) and event.is_pressed():
		scroll_by(-1)
	if (event.is_action("down") or event.is_action("scroll_down")) and event.is_pressed():
		scroll_by(1)
