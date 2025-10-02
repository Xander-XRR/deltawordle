extends Node2D

var hue: float = 0.0
@onready var texture_1: TextureRect = $Texture1
@onready var texture_2: TextureRect = $Texture2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hue = fmod(hue + delta * 0.05, 1.0)
	var color = Color.from_hsv(hue, 0.75, 1.0, 1.0)
	modulate = color
	texture_1.modulate = Color(color, 0.5)
	texture_2.modulate = Color(color, 0.5)
	
