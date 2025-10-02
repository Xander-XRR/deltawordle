extends Control


@export var target_bus: String = "Master"

@onready var setting_name: Label = $Name
@onready var value_label: Label = $Value
@onready var h_slider: HSlider = $HSlider
@onready var audio_stream_player: AudioStreamPlayer = $"../../AudioStreamPlayer"
@onready var soul_magnet: SoulMagnet = $HSlider/SoulMagnet


func _ready() -> void:
	var volume_to_be_loaded: float
	match target_bus:
		"Master":
			volume_to_be_loaded = Settings.master_volume
		"SFX":
			volume_to_be_loaded = Settings.sfx_volume
		"Music":
			volume_to_be_loaded = Settings.music_volume
	
	h_slider.value = volume_to_be_loaded
	
	if h_slider.value == 0.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(target_bus), true)
	value_label.text = str(int(h_slider.value)) + "%"
	
	h_slider.value_changed.connect(_on_h_slider_value_changed)
	h_slider.focus_entered.connect(_on_h_slider_focus.bind(true))
	h_slider.mouse_entered.connect(_on_h_slider_focus)
	h_slider.focus_exited.connect(_on_h_slider_unfocus.bind(true))
	h_slider.mouse_exited.connect(_on_h_slider_unfocus)
	


func _on_h_slider_value_changed(value: float, silent: bool = false) -> void:
	value_label.text = str(int(value)) + "%"
	
	var bus = AudioServer.get_bus_index(target_bus)
	
	match target_bus:
		"Master":
			Settings.master_volume = value
		"SFX":
			Settings.sfx_volume = value
		"Music":
			Settings.music_volume = value
	
	if value == 0.0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		var db = lerp(db_to_linear(-80), db_to_linear(0), value / 100)
		AudioServer.set_bus_volume_linear(bus, db)
		if !silent:
			audio_stream_player.play()
	

func _on_h_slider_focus(true_focus: bool = false) -> void:
	if !setting_name.text.begins_with("  "):
		setting_name.text = "  " + setting_name.text
	if true_focus:
		setting_name.self_modulate = Color.YELLOW
	

func _on_h_slider_unfocus(true_unfocus: bool = false) -> void:
	setting_name.text = setting_name.text.trim_prefix("  ")
	if true_unfocus:
		setting_name.self_modulate = Color.WHITE
