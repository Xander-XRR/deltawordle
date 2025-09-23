extends Button
class_name HoverButton

@export var text_size_overrides: Vector2i = Vector2i(20, 25)
@export var soul_offset: Vector2 = Vector2(0.0, 0.0)
@export var soul_node_override: Soul

var soul_magnet: SoulMagnet = SoulMagnet.new()
var tween: Tween

var dummy_tex: ImageTexture
var soul_owned: bool = false

signal set_ownership(is_owned: bool)


func _ready() -> void:
	add_child(soul_magnet)
	
	soul_magnet.set_anchors_preset(Control.PRESET_FULL_RECT)
	soul_magnet.soul_offset = soul_offset
	if soul_node_override:
		soul_magnet.soul = soul_node_override
	
	focus_entered.connect(set_icon)
	focus_exited.connect(rid_icon)
	mouse_entered.connect(set_icon)
	mouse_exited.connect(rid_icon)
	
	set_theme_font_override_smooth(text_size_overrides.x)
	

func set_icon() -> void:
	set_theme_font_override_smooth(text_size_overrides.y)
	

func rid_icon() -> void:
	set_theme_font_override_smooth(text_size_overrides.x)
	

func set_theme_font_override_smooth(new_size: int) -> void:
	var init_font_size = get_theme_font_size("font_size")
	var current_font_size = init_font_size
	var change_sign = 1 if current_font_size < new_size else -1
	
	while is_inside_tree() and ((current_font_size < new_size) if change_sign == 1 else (current_font_size > new_size)):
		current_font_size += change_sign * 2
		add_theme_font_size_override("font_size", current_font_size)
		await get_tree().process_frame
	
