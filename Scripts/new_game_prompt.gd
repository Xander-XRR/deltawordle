@tool
extends DeltaWindow

@onready var option_button: OptionButton = $OptionButton

signal new_game_requested

func _on_start_pressed() -> void:
	Global.word_size = option_button.selected + 3
	new_game_requested.emit()
	
