extends Panel


@onready var announcement: Label = $Announcement
@onready var word: Label = $Word

func announce(won: bool, w_word: String):
	visible = true
	
	var win_state = "WON" if won else "LOST"
	
	announcement.text = announcement.text.replace("EXIST", win_state)
	word.text = word.text.replace("word", w_word)
	


func _on_return_title_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
