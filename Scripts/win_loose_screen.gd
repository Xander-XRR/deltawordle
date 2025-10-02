@tool
extends DeltaWindow


@onready var announcement: Label = $Announcement
@onready var word: Label = $Word


func announce(won: bool, w_word: String):
	window_popup(true)
	
	var win_state = "WON" if won else "LOST"
	
	announcement.text = announcement.text.replace("EXIST", win_state)
	word.text = word.text.replace("word", w_word)
	


func _on_new_game_pressed() -> void:
	SceneTransition.transition_to_scene("res://Scenes/game.tscn")


func _on_back_to_title_pressed() -> void:
	SceneTransition.transition_to_scene("res://Scenes/main.tscn")
