extends ColorRect


@onready var echo_particle_emitter: Node2D = $EchoParticleEmitter

@onready var music_levels: Node = $MusicLevels
@onready var current_music_player: AudioStreamPlayer = $MusicLevels/StatueLevel1

var music_level: int = 0


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_accept"):
		_on_music_escalate()


func _on_music_escalate() -> void:
	music_level += 1
	if music_level < 9:
		echo_particle_emitter.frequency -= echo_particle_emitter.frequency / 7.0
		echo_particle_emitter.wanted_color = lerp(echo_particle_emitter.wanted_color, Color.RED, music_level / 10.0)
		
		var new_music_player = music_levels.get_child(music_level)
		
		var tween = create_tween()
		tween.tween_property(current_music_player, "volume_linear", 0.0, 1.0)
		tween.parallel().tween_property(new_music_player, "volume_linear", 1.0, 1.0)
		current_music_player = new_music_player
	
