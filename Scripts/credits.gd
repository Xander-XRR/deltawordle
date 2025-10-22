extends Control


@onready var background: ColorRect = $Background
@onready var names: Node2D = $Names

var bg_colors: Array = [
	Color.CADET_BLUE,
	Color.CRIMSON,
	Color.DARK_MAGENTA,
	Color.BLACK,
]

var links: Array = [
	"https://bsky.app/profile/xanderxrr.bsky.social",
	"https://deltarune.com/",
	"https://www.youtube.com/@netziguess3507",
	"@return"
]


func _ready() -> void:
	GlobalSoul.soul.visible = false
	tween_color_to(bg_colors[0])


func tween_color_to(col: Color) -> void:
	create_tween().tween_property(background, "color", col, 1.0).set_ease(Tween.EASE_OUT)


func _on_names_new_selected(index: int) -> void:
	tween_color_to(bg_colors[index])


func _input(event: InputEvent) -> void:
	if (event.is_action("enter") or event.is_action("left_mouse_button")) and event.is_pressed():
		var link = links[names.selected.get_index()]
		if link == "@return":
			SceneTransition.transition_to_scene("res://Scenes/main.tscn")
		else:
			OS.shell_open(link)
