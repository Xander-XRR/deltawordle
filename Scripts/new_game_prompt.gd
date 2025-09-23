extends Window

@onready var option_button: OptionButton = $OptionButton

func _on_close_requested() -> void:
	hide()
	$AudioStreamPlayer.play()

func _on_start_pressed() -> void:
	Global.word_size = option_button.selected + 3
	print(Global.word_size)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
