extends Panel


@onready var letter_options: OptionButton = $LetterOptions
@onready var sfx_player_noise: AudioStreamPlayer = $SFXPlayerNoise
@onready var sfx_player_select: AudioStreamPlayer = $SFXPlayerSelect

const DELTARUNE_BATTLE_BOX_STYLE = preload("uid://d2syknyok7j2h")

signal close_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var popup = letter_options.get_popup()
	popup.add_theme_stylebox_override("panel", DELTARUNE_BATTLE_BOX_STYLE)


func _on_close_pressed() -> void:
	visible = false
	sfx_player_select.play()
	close_requested.emit()


func _on_letter_options_item_selected(_index: int) -> void:
	sfx_player_noise.play()


func _on_start_new_game_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/alt_game.tscn")
