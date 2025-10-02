extends Node2D


@onready var thing_body: Sprite2D = $ThingBody
@onready var thing_head: Sprite2D = $ThingHead
@onready var thing_wing_1: Sprite2D = $ThingWing1
@onready var thing_wing_2: Sprite2D = $ThingWing2
@onready var thing_wing_3: Sprite2D = $ThingWing3
@onready var thing_wing_4: Sprite2D = $ThingWing4

var time: float = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	thing_body.offset.y = sin(time / 1.5) * 5.0
	thing_head.offset.y = sin(time / 1.5 - 0.3) * 5.0
	thing_wing_1.offset.y = sin(time / 1.7 - 0.5) * 8.5
	thing_wing_2.offset.y = sin(time / 1.2 + 0.5) * 10.0
	thing_wing_3.offset.y = sin(time / 0.9 - 1.4) * 7.0
	thing_wing_4.offset.y = sin(time + 1.7) * 7.5
	
