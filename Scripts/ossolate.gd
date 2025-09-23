extends TextureRect


@export var vertical: bool = false
@export var max_offset: float = 25
@export var alpha_value: float = 1.0
@export var speed: float = 1.0
var init_position: Vector2
var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_position = global_position
	self_modulate.a = alpha_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta * speed
	
	if !vertical:
		global_position = Vector2(init_position.x - max_offset + sin(time) * max_offset, global_position.y)
	else:
		global_position = Vector2(global_position.x, init_position.y - max_offset + sin(time) * max_offset)
	
