## Global Class controlling Settings related functionality.
extends Node

const SAVE_PATH: String = "user://settings.cfg"

var master_volume: float = 30.0
var sfx_volume: float = 50.0
var music_volume: float = 50.0
var last_played_menu_theme: String = "ANNOYING_PROPHECY"
var last_played_game_theme: String = ""
var encountered_experiment: bool = false

signal update_volume_labels(master, sfx, music)


func _ready() -> void:
	load_settings()
	


func save_single_setting(setting_name: String, value) -> void:
	var file = ConfigFile.new()
	var err = file.load(SAVE_PATH)
	if err == OK:
		file.set_value("settings", setting_name, value)
		file.save(Settings.SAVE_PATH)
	else:
		print("No Settings file found.")


func load_single_setting(setting_name: String, default) -> Variant:
	var file = ConfigFile.new()
	var err = file.load(SAVE_PATH)
	if err == OK:
		return file.get_value("settings", setting_name, default)
	else:
		print("No Settings file found.")
		return default


func save_settings() -> void:
	var file = ConfigFile.new()
	file.load(SAVE_PATH)
	file.set_value("settings", "master_volume", master_volume)
	file.set_value("settings", "music_volume", music_volume)
	file.set_value("settings", "sfx_volume", sfx_volume)
	file.set_value("settings", "last_played_menu_theme", last_played_menu_theme)
	file.set_value("settings", "last_played_game_theme", last_played_game_theme)
	var err = file.save(SAVE_PATH)
	if err != OK:
		push_error("Failed saving Settings: %s" % err)


func load_settings() -> void:
	var file = ConfigFile.new()
	var err = file.load(SAVE_PATH)
	if err == OK:
		master_volume = file.get_value("settings", "master_volume", master_volume)
		sfx_volume = file.get_value("settings", "sfx_volume", sfx_volume)
		music_volume = file.get_value("settings", "music_volume", music_volume)
		last_played_menu_theme = file.get_value("settings", "last_played_menu_theme", last_played_menu_theme)
		last_played_game_theme = file.get_value("settings", "last_played_game_theme", last_played_game_theme)
		encountered_experiment = file.get_value("settings", "encountered_experiment", encountered_experiment)
	else:
		print("No Settings file found, using defaults.")
	
	_apply_loaded_settings()
	

func _apply_loaded_settings() -> void:
	# Audio
	update_volume_labels.emit(master_volume, sfx_volume, music_volume)
	
	# Master Volume
	if master_volume == 0.0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		var db = lerp(db_to_linear(-80), 1.0, master_volume / 100)
		AudioServer.set_bus_volume_linear(0, db)
	
	# SFX Volume
	if sfx_volume == 0.0:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		var db = lerp(db_to_linear(-80), 1.0, sfx_volume / 100)
		AudioServer.set_bus_volume_linear(2, db)
	
	# Music Volume
	if music_volume == 0.0:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		var db = lerp(db_to_linear(-80), 1.0, music_volume / 100)
		AudioServer.set_bus_volume_linear(1, db)
	
