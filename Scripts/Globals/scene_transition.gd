## Global Class Controlling transition bars.
extends CanvasLayer
class_name BarsPlayer


@onready var bar_upper: ColorRect = ColorRect.new()
@onready var bar_lower: ColorRect = ColorRect.new()
@onready var input_blocker: Control = Control.new()

var window_height: float
var window_width: float


func _ready() -> void:
	window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	
	bar_upper.size = Vector2(window_width, 0.0)
	bar_lower.size = Vector2(window_width, 0.0)
	input_blocker.size = Vector2(window_width, window_height)
	
	bar_lower.position.y = window_height
	
	bar_upper.color = Color.BLACK
	bar_lower.color = Color.BLACK
	
	input_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_child(bar_upper)
	add_child(bar_lower)
	add_child(input_blocker)
	


func transition_to_scene(new_scene, time: float = 1.0) -> void:
	input_blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = create_tween()
	var old_volume = AudioServer.get_bus_volume_linear(1)
	
	animate_vertical_bars(400.0, 1.0)
	await tween.tween_method(
		func(vol): AudioServer.set_bus_volume_linear(1, vol),
		AudioServer.get_bus_volume_linear(1),
		0.0,
		time
	).finished
	
	if new_scene is PackedScene:
		get_tree().call_deferred("change_scene_to_packed", new_scene)
	else:
		get_tree().call_deferred("change_scene_to_file", new_scene)
	
	await get_tree().process_frame
	
	tween = create_tween()
	tween.tween_method(
		func(vol): AudioServer.set_bus_volume_linear(1, vol),
		AudioServer.get_bus_volume_linear(1),
		old_volume,
		1.0
	)
	animate_vertical_bars(0.0, 1.0)
	input_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	

func set_vertical_bars(to: float):
	bar_upper.size.y = to
	bar_lower.size.y = to
	bar_lower.position.y = window_height - to
	Debug.dprint(self, "(SET): set vertical bars to ", to)
	

func animate_vertical_bars(to: float, duration: float = 1.0) -> void:
	var tween = create_tween()
	Debug.dprint(self, "(TWEEN START): tweening vertical bars to ", to)
	tween.tween_property(bar_upper, "size", Vector2(bar_upper.size.x, to), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(bar_lower, "position", Vector2(bar_lower.position.x, window_height - to), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tween.parallel().tween_property(bar_lower, "size", Vector2(bar_lower.size.x, to), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).finished
	Debug.dprint(self, "(TWEEN END): finished tweening vertical bars to ", to)
	
