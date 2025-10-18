extends CanvasLayer
class_name MusicInteract


@onready var color_rect: ColorRect = $ColorRect
@onready var title_control: Control = $CanvasLayer/TitleControl
@onready var title: Label = $CanvasLayer/TitleControl/Title
@onready var title_2: Label = $CanvasLayer/TitleControl/Title2
@onready var title_3: Label = $CanvasLayer/TitleControl/Title3
@onready var title_4: Label = $CanvasLayer/TitleControl/Title4
@onready var remix_player: AudioStreamPlayer = $RemixPlayer

const SMALL_STAMP = 0.186
const BIG_STAMP = 1.55

var times_stamps: Array =[
	0.2, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP,
	BIG_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP,
	BIG_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP,
	BIG_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP,
	BIG_STAMP, "", SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP,
	BIG_STAMP, "", SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP,
	BIG_STAMP, "", SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP,
	BIG_STAMP, "", SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, SMALL_STAMP, ""
]

var current_stamp: int = 0
var time: float = 0
var is_processing_time_stamps: bool = true
var particle_array: Array = [null, null, null, null, null, null, null, null]
var interupt_index: int = 0

const ECHO_PARTICLE = preload("uid://bock1hddw04nc")

signal time_stamp_met
signal interupt(num: int)

func _ready() -> void:
	time_stamp_met.connect(_on_time_stamp_met)
	interupt.connect(_on_interupt)


func fade_out() -> void:
	title.visible = false
	title_2.visible = false
	title_3.visible = false
	title_4.visible = false
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.color = Color.WHITE
	create_tween().tween_property(color_rect, "color", Color.TRANSPARENT, 1.0)


func _process(delta: float) -> void:
	time += delta 
	if is_processing_time_stamps:
		if times_stamps[current_stamp] is String:
			interupt.emit(interupt_index)
			interupt_index += 1
			
			if current_stamp < times_stamps.size() - 1:
				current_stamp += 1
			else:
				is_processing_time_stamps = false
				return
		
		if time >= times_stamps[current_stamp]:
			time_stamp_met.emit()
			time = 0
			
			if current_stamp < times_stamps.size() - 1:
				current_stamp += 1
			else:
				is_processing_time_stamps = false


func _on_time_stamp_met() -> void:
	var particle: EchoParticle = ECHO_PARTICLE.instantiate()
	
	var found_slot = -1
	for i in range(particle_array.size()):
		if particle_array[i] == null:
			particle_array[i] = particle
			found_slot = i
			break
		i += 1
	
	if found_slot != -1:
		particle_array[found_slot] = particle
	else:
		particle_array.append(particle)
		push_warning("Particle Array filled, appended new Particle.")
	
	particle.connect("tree_exited", func(): particle_array[found_slot] = null)
	
	particle.z_index = found_slot * 4
	particle.position = Vector2(randf_range(50.0, 1102.0), randf_range(50.0, 598.0))
	particle.distance = 100.0
	particle.speed = 0.8
	add_child(particle)
	


func _on_interupt(num: int) -> void:
	print("interupt Nr. ", num)
	if num == 0:
		title.visible = true
	if num == 1:
		title_2.visible = true
	if num == 2:
		title_3.visible = true
	if num == 3:
		title_4.visible = true
	if num == 4:
		await create_tween().tween_property(title_control, "modulate", Color.TRANSPARENT, BIG_STAMP).finished
		fade_out()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_button") and is_processing_time_stamps:
		color_rect.color = Color.WHITE
		is_processing_time_stamps = false
		remix_player.stop()
		for particle: EchoParticle in particle_array:
			if particle != null:
				particle.queue_free()
		remix_player.play(25.7)
		fade_out()
	
