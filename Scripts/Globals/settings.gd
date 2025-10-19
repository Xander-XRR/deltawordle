## Global Class controlling Settings related functionality.
extends CanvasLayer


const SAVE_PATH: String = "user://settings.cfg"
const SETTINGS = preload("res://Scenes/settings.tscn")

@onready var settings_window: SettingsWindows = SETTINGS.instantiate()

var settings_file_existed_on_startup: bool = false

var master_volume: float = 30.0
var sfx_volume: float = 50.0
var music_volume: float = 50.0
var last_played_menu_theme: String = "ANNOYING_PROPHECY"
var last_played_game_theme: String = ""
var encountered_experiment: bool = false
var fullscreen: bool = false
var knows_silly_bugs_dangers: bool = false
var enable_silly_bugs: bool = false

signal update_volume_labels(master, sfx, music)
signal settings_window_popup_requested
signal settings_window_hide_requested

func _ready() -> void:
	load_settings()
	
	layer = 2
	
	settings_window.visible = false
	settings_window.popup_requested.connect(func(): settings_window_popup_requested.emit())
	settings_window.close_requested.connect(func(): settings_window_hide_requested.emit())
	add_child(settings_window)
	


func show_settings_window() -> void:
	settings_window.window_popup(true)
	


func hide_settings_window() -> void:
	settings_window.window_hide()
	


func save_single_setting(setting_name: String, value) -> void:
	var file = ConfigFile.new()
	var err = file.load(SAVE_PATH)
	if err == OK:
		file.set_value("settings", setting_name, value)
		file.save(Settings.SAVE_PATH)
	else:
		print("Settings: No Settings file found.")


func load_single_setting(setting_name: String, default) -> Variant:
	var file = ConfigFile.new()
	var err = file.load(SAVE_PATH)
	if err == OK:
		return file.get_value("settings", setting_name, default)
	else:
		print("Settings: No Settings file found.")
		return default


func save_settings() -> void:
	var file = ConfigFile.new()
	file.load(SAVE_PATH)
	file.set_value("settings", "master_volume", master_volume)
	file.set_value("settings", "music_volume", music_volume)
	file.set_value("settings", "sfx_volume", sfx_volume)
	file.set_value("settings", "last_played_menu_theme", last_played_menu_theme)
	file.set_value("settings", "last_played_game_theme", last_played_game_theme)
	file.set_value("settings", "fullscreen", fullscreen)
	file.set_value("settings", "knows_silly_bugs_dangers", knows_silly_bugs_dangers)
	file.set_value("settings", "enable_silly_bugs", enable_silly_bugs)
	var err = file.save(SAVE_PATH)
	if err != OK:
		push_error("Settings: Failed saving Settings: %s" % err)


func load_settings() -> void:
	var file = ConfigFile.new()
	var err = file.load(SAVE_PATH)
	if err == OK:
		settings_file_existed_on_startup = true
		master_volume = file.get_value("settings", "master_volume", master_volume)
		sfx_volume = file.get_value("settings", "sfx_volume", sfx_volume)
		music_volume = file.get_value("settings", "music_volume", music_volume)
		last_played_menu_theme = file.get_value("settings", "last_played_menu_theme", last_played_menu_theme)
		last_played_game_theme = file.get_value("settings", "last_played_game_theme", last_played_game_theme)
		encountered_experiment = file.get_value("settings", "encountered_experiment", encountered_experiment)
		fullscreen = file.get_value("settings", "fullscreen", fullscreen)
		knows_silly_bugs_dangers = file.get_value("settings", "knows_silly_bugs_dangers", knows_silly_bugs_dangers)
		enable_silly_bugs = file.get_value("settings", "enable_silly_bugs", enable_silly_bugs)
		
		print("Settings:",
			"\n\tmaster_volume: ", master_volume,
			"\n\tmusic_volume: ", music_volume,
			"\n\tsfcx_volume: ", sfx_volume,
			"\n\tlast_played_menu_theme: ", last_played_menu_theme,
			"\n\tlast_played_game_theme: ", last_played_game_theme,
			"\n\tencountered_experiment: ", encountered_experiment,
			"\n\tfullscreen: ", fullscreen,
			"\n\tknows_silly_bugs_dangers: ", knows_silly_bugs_dangers,
			"\n\tenable_silly_bugs: ", enable_silly_bugs,
		)
	else:
		settings_file_existed_on_startup = false
		print("Settings: No Settings file found, using defaults.")
	
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
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
