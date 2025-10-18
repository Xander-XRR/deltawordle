extends Control


@onready var label: Label = $Label

var text_length: int = 0
var raw_text: String
var normal_cooldown: float = 0.05
var special_cooldown_1: float = 0.3
var special_cooldown_2: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_length = label.text.length()
	raw_text = label.text
	label.text = label.text.replace("&", "\u200B")
	label.text = label.text.replace("|", "\u200B")
	label.visible_characters = 0
	show_text()


func show_text() -> void:
	var i = 0
	for letter in raw_text:
		label.visible_characters += 1
		
		var cooldown = normal_cooldown
		match raw_text[i]:
			",":
				cooldown += 0.15
			".":
				cooldown += 0.3
			"&":
				cooldown = special_cooldown_1
			"|":
				cooldown = special_cooldown_2
		
		await get_tree().create_timer(cooldown).timeout
		i += 1
