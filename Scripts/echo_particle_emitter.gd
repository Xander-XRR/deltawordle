extends Node2D

@export var frequency: float = 3.0
@export var wanted_color: Color = Color.WHITE

const ECHO_PARTICLE = preload("uid://bock1hddw04nc")


func _ready() -> void:
	_spawn_particle()

func _spawn_particle() -> void:
	while true:
		var p: Line2D = ECHO_PARTICLE.instantiate()
		add_child(p)
		
		p.default_color = wanted_color
		p.get_child(0).default_color = wanted_color.darkened(0.2)
		p.get_child(1).default_color = wanted_color.darkened(0.4)
		p.get_child(2).default_color = wanted_color.darkened(0.6)
		
		await get_tree().create_timer(frequency).timeout
