extends RichTextLabel
class_name GayTextLabel
#its 12 20 am im tired ok?

@onready var ghost_1: RichTextLabel = $"../Ghost1"
@onready var ghost_2: RichTextLabel = $"../Ghost2"
@onready var ghost_3: RichTextLabel = $"../Ghost3"
@onready var revolution_point: Node2D = $"../RevolutionPoint"

var time: float = 0.0
var radius: float = 50.0
var speed: float = 1.0
var vector_mult: Vector2 = Vector2(1.25, 0.75)
var offset: float = 2


func _ready() -> void:
	ghost_1.append_text(text)
	ghost_2.append_text(text)
	ghost_3.append_text(text)
	
	ghost_1.size = size
	ghost_2.size = size
	ghost_3.size = size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	ghost_1.global_position = revolution_point.global_position + Vector2(sin(time * speed) * radius * vector_mult.x, cos(time * speed) * radius * vector_mult.y)
	ghost_2.global_position = revolution_point.global_position + Vector2(sin((time + offset) * speed) * radius * vector_mult.x, cos((time + offset) * speed) * radius * vector_mult.y)
	ghost_3.global_position = revolution_point.global_position + Vector2(sin((time - offset) * speed) * radius * vector_mult.x, cos((time - offset) * speed) * radius * vector_mult.y)
	
