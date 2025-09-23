extends Sprite2D
class_name Soul


enum State { OWNED, GRACE, FREE }
var state = State.OWNED

const TRANSER_GRACE_PERIOD: float = 0.02


var time: float = 0.0
var owned: bool = true
var time_off_owner: float = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	offset.y = sin(time * 2.0) * 7.0
	
	match state:
		State.OWNED:
			pass
			
		State.GRACE:
			time_off_owner += delta
			if time_off_owner >= TRANSER_GRACE_PERIOD:
				state = State.FREE
			
		State.FREE:
			var tween = create_tween()
			tween.tween_property(self, "global_position", get_global_mouse_position(), 0.1)
			#global_position = get_global_mouse_position()
	

func _on_set_ownership(is_owned: bool) -> void:
	if is_owned:
		state = State.OWNED
	else:
		state = State.GRACE
		time_off_owner = 0.0
	
