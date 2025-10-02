extends Control
class_name SoulMagnet


@export var soul: Soul
@export var soul_offset: Vector2 = Vector2(50.0, 0.0)
@export var text_size_overrides: Vector2i = Vector2i(20, 25)

const SND_NOISE = preload("res://Assets/Audio/SFX/snd_menumove.wav")
const SND_SELECT = preload("res://Assets/Audio/SFX/snd_select.wav")

var parent: Control
var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
var tween: Tween

var dummy_tex: ImageTexture
var soul_owned: bool = false

signal set_ownership(is_owned: bool)


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	parent = get_parent_control()
	add_child(audio_player)
	
	if !soul:
		soul = get_tree().current_scene.get_node("Soul")
		if !soul:
			push_error("No Soul Node Found.")
	
	parent.focus_entered.connect(set_owned)
	parent.focus_exited.connect(set_disowned)
	parent.mouse_entered.connect(set_owned)
	parent.mouse_exited.connect(set_disowned)
	parent.gui_input.connect(_on_gui_input)
	
	set_ownership.connect(Callable(soul, "_on_set_ownership"))
	
	set_theme_font_override_smooth(text_size_overrides.x)
	
	audio_player.bus = "SFX"
	


func set_owned() -> void:
	if soul:
		audio_player.stream = SND_NOISE
		audio_player.play()
		tween = create_tween()
		tween.tween_property(soul, "global_position", global_position + Vector2(soul_offset.x, (parent.size.y / 2 if soul_offset.y == 0.0 else soul_offset.y)), 0.4) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT)
		set_theme_font_override_smooth(text_size_overrides.y)
		
		set_ownership.emit(true)
		soul_owned = true
	


func set_disowned() -> void:
	if tween:
		tween.stop()
	set_ownership.emit(false)
	set_theme_font_override_smooth(text_size_overrides.x)
	


func set_theme_font_override_smooth(new_size: int) -> void:
	var init_font_size = get_theme_font_size("font_size")
	var current_font_size = init_font_size
	var change_sign = 1 if current_font_size < new_size else -1
	
	while is_inside_tree() and ((current_font_size < new_size) if change_sign == 1 else (current_font_size > new_size)):
		current_font_size += change_sign * 2
		add_theme_font_size_override("font_size", current_font_size)
		await get_tree().process_frame
	


func play_sound_select() -> void:
	audio_player.stream = SND_SELECT
	audio_player.play()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("left_mouse_button") and soul_owned:
		play_sound_select()
		
