extends OptionButton


@export var text_offset: int = 50

var dummy_tex_small: ImageTexture
var dummy_tex: ImageTexture
var soul_owned: bool = false


func _ready() -> void:
	focus_entered.connect(set_icon)
	mouse_entered.connect(set_icon)
	focus_exited.connect(rid_icon)
	mouse_exited.connect(rid_icon)
	
	var img_size = text_offset
	var img = Image.create(img_size, 10, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	dummy_tex = ImageTexture.create_from_image(img)
	
	img_size = 20
	img = Image.create(img_size, 10, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	dummy_tex_small = ImageTexture.create_from_image(img)
	
	icon = dummy_tex_small
	

func set_icon() -> void:
	icon = dummy_tex
	set_theme_font_override_smooth(25)

func rid_icon() -> void:
	icon = dummy_tex_small
	set_theme_font_override_smooth(20)


func set_theme_font_override_smooth(new_size: int) -> void:
	var init_font_size = get_theme_font_size("font_size")
	var current_font_size = init_font_size
	var change_sign = 1 if current_font_size < new_size else -1
	
	while is_inside_tree() and ((current_font_size < new_size) if change_sign == 1 else (current_font_size > new_size)):
		current_font_size += change_sign * 2
		add_theme_font_size_override("font_size", current_font_size)
		await get_tree().process_frame


func _on_item_selected(_index: int) -> void:
	rid_icon()
