extends OptionButton
class_name HoverOptionButton


@onready var soul: Sprite2D = $"../Soul"

@export var soul_offset: float = 50.0
@export var text_offset: int
@export var text_size_overrides: Vector2i = Vector2i(20, 25)

const SND_NOISE = preload("res://Assets/Audio/SFX/snd_menumove.wav")
const SND_SELECT = preload("res://Assets/Audio/SFX/snd_select.wav")

var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
var tween: Tween

var dummy_tex_small: ImageTexture
var dummy_tex: ImageTexture
var soul_owned: bool = false

signal set_ownership(is_owned: bool)


func _ready() -> void:
	audio_player.bus = "SFX"
	add_child(audio_player)
	
	focus_entered.connect(set_icon)
	focus_exited.connect(rid_icon)
	mouse_entered.connect(set_icon)
	mouse_exited.connect(rid_icon)
	pressed.connect(_on_button_pressed)
	set_ownership.connect(Callable(soul, "_on_set_ownership"))
	
	var img_size = (text.length() * 2 + 30) if !text_offset else text_offset
	var img = Image.create(img_size, 10, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	dummy_tex = ImageTexture.create_from_image(img)
	
	img_size = 30
	img = Image.create(img_size, 10, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	dummy_tex_small = ImageTexture.create_from_image(img)
	
	icon = dummy_tex_small
	
	set_theme_font_override_smooth(text_size_overrides.x)
	

func set_icon() -> void:
	audio_player.stream = SND_NOISE
	audio_player.play()
	
	if soul:
		tween = create_tween()
		tween.tween_property(soul, "global_position", global_position + Vector2(soul_offset, size.y / 2), 0.4) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT)
		set_theme_font_override_smooth(text_size_overrides.y)
		
		icon = dummy_tex
		
		set_ownership.emit(true)
		soul_owned = true
		

func rid_icon() -> void:
	icon = dummy_tex_small
	if tween:
		tween.stop()
	set_ownership.emit(false)
	set_theme_font_override_smooth(text_size_overrides.x)
	

func set_theme_font_override_smooth(new_size: int) -> void:
	var init_font_size = get_theme_font_size("font_size")
	var current_font_size = init_font_size
	var change_sign = 1 if current_font_size < new_size else -1
	
	while (current_font_size < new_size) if change_sign == 1 else (current_font_size > new_size):
		current_font_size += change_sign * 2
		add_theme_font_size_override("font_size", current_font_size)
		await get_tree().process_frame
	


func _on_button_pressed() -> void:
	audio_player.stream = SND_SELECT
	audio_player.play()


func _on_item_selected(_index: int) -> void:
	audio_player.stream = SND_SELECT
	audio_player.play()
	rid_icon()
