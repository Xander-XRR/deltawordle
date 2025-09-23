extends Window


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_save: AudioStreamPlayer = $AudioStreamPlayerSave


func _on_close_requested() -> void:
	hide()
	Settings.save_settings()
	audio_stream_player_save.play()
