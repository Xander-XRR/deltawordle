extends SingleDisplay
class_name SingleLetterDisplay


@onready var audio_player: AudioStreamPlayer = $AudioPlayer
@onready var control: Control = $SoulMagnet

const SND_MENUMOVE = preload("res://Assets/Audio/SFX/snd_menumove.wav")
const SND_SELECT = preload("res://Assets/Audio/SFX/snd_select.wav")

enum LetterState { NEUTRAL, UNUSED, USED, PERFECT }
var current_letter_state = LetterState.NEUTRAL

var selected_key: bool = false


func _ready() -> void:
	panel.add_theme_stylebox_override("panel", DELTARUNE_OPTION_STYLE)
	
	if initial_letter:
		label.text = initial_letter
	
	if control_character:
		custom_minimum_size.x *= 2
		update_minimum_size()
		size.x *= 2
		panel.size.x *= 2
		label.size.x *= 2
	
	audio_player.bus = "SFX"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -6)
	
	


func set_letter_state(new_state: LetterState) -> void:
	match new_state:
		LetterState.UNUSED:
			current_letter_state = LetterState.UNUSED
			label.text = "[color=ff0000]"+ initial_letter +"[/color]"
		LetterState.USED:
			if current_letter_state != LetterState.PERFECT:
				current_letter_state = LetterState.USED
				label.text = "[color=ffff00]"+ initial_letter +"[/color]"
		LetterState.PERFECT:
			current_letter_state = LetterState.PERFECT
			label.text = "[color=008000]"+ initial_letter +"[/color]"
	


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("left_mouse_button") and selected_key:
		audio_player.stream = SND_SELECT
		audio_player.play()
		print(label.text)


func _on_control_mouse_entered() -> void:
	audio_player.stream = SND_MENUMOVE
	audio_player.play()
	selected_key = true
	set_theme_style()


func _on_control_mouse_exited() -> void:
	selected_key = false
	set_theme_style(false)
