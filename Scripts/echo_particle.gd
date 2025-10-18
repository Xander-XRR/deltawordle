extends Line2D
class_name EchoParticle


@export var speed: float = 1.5
@export var distance: float = 100.0
@export var max_width: float = 15.0
@export var echo: bool = false
@export var echo_distance_subtraction: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if echo:
		var parent: EchoParticle = get_parent()
		if parent:
			width = parent.width
			max_width = parent.max_width
			distance = parent.distance - echo_distance_subtraction * (get_index() + 1)
			speed = parent.speed
	
	emit()
	


func emit() -> void:
	var target_points: Array[Vector2] = []
	var angle = 360.0 / points.size()
	var p_index = 1
	
	for p in points:
		var angle_rad = deg_to_rad(angle * p_index)
		var new_x = p.x + cos(angle_rad) * distance
		var new_y = p.y + sin(angle_rad) * distance
		var target_pos = Vector2(new_x, new_y)
		
		p_index += 1
		
		target_points.append(p + target_pos)
	
	for i in range(points.size()):
		var tween = create_tween()
		tween.tween_method(
			func(v): _set_point(i, v),
			points[i],
			target_points[i],
			speed
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	var gen_tween = create_tween()
	#Color(modulate.r, modulate.g, modulate.b, 0.0)
	gen_tween.tween_property(self, "modulate", Color.BLACK, speed) \
	.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	gen_tween.parallel().tween_property(self, "width", max_width, speed)
	
	await gen_tween.finished
	queue_free()
	


func _set_point(index: int, value: Vector2) -> void:
	set_point_position(index, value)
