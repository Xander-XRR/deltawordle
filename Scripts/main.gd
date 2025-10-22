extends Control


@onready var soul: Soul = GlobalSoul.soul
@onready var screen_tint: ColorRect = $ScreenTint
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var select_sfx_player: AudioStreamPlayer = $SelectSFXPlayer
@onready var title_dog: Sprite2D = $TitleDog
@onready var title_shadered: Sprite2D = $TitleShadered
@onready var button_manager: Node = $ButtonManager
@onready var fake_buttons: Node2D = $FakeButtons
@onready var back_sfx_player: AudioStreamPlayer = $BackSFXPlayer

const GAME = preload("res://Scenes/game.tscn")
const NETZ_REMIX_MUSIC_INTERACT = preload("res://Scenes/music_interact.tscn")

# Menu Music [file path, starting point, volume (DB)]
var menu_music: Dictionary = {
	ALT_CHURCH_LOBBY = ["res://Assets/Audio/Music/alt_church_lobby.ogg"],
	ANNOYING_PROPHECY = ["res://Assets/Audio/Music/annoying_prophecy.ogg"],
	AUDIO_ANOTHERHIM = ["res://Assets/Audio/Music/AUDIO_ANOTHERHIM.ogg"],
	AUDIO_STORY = ["res://Assets/Audio/Music/AUDIO_STORY.ogg"],
	CH_4_CREDITS = ["res://Assets/Audio/Music/ch4_credits.ogg", 15.15, 2],
	CHURCH_ZONE_3 = ["res://Assets/Audio/Music/church_zone3.ogg", 25.4, 6],
	DOGCHECK = ["res://Assets/Audio/Music/dogcheck.ogg"],
	KRIS_PIANO_WAITINGROOM = ["res://Assets/Audio/Music/kris_piano_waitingroom.ogg"],
	MENU = ["res://Assets/Audio/Music/menu.ogg"],
	NOELLE = ["res://Assets/Audio/Music/noelle.ogg"],
	QUIET_AUTUMN = ["res://Assets/Audio/Music/quiet_autumn.ogg"],
	QUIET_CHURCH = ["res://Assets/Audio/Music/quiet_church.ogg"],
	SECOND_CHURCH = ["res://Assets/Audio/Music/second_church.ogg",  25.4, 6],
	SHOP_1 = ["res://Assets/Audio/Music/shop1.ogg"],
	THE_HOLY = ["res://Assets/Audio/Music/THE_HOLY.ogg"],
	TOWN = ["res://Assets/Audio/Music/town.ogg"]
}


func _ready() -> void:
	GlobalSoul.soul.visible = true
	$ButtonManager/Start.grab_focus()
	
	Settings.connect("settings_window_hide_requested", _on_main_menu_settings_close_requested)
	DeltaWindowsLayer.new_game_prompt.close_requested.connect(_on_new_game_prompt_close_requested)
	DeltaWindowsLayer.new_game_prompt.new_game_requested.connect(_on_new_game_prompt_new_game_requested)
	DeltaWindowsLayer.license_window.close_requested.connect(_on_license_window_close_requested)
	
	if Global.custom_intro == Global.CustomIntros.CHURCH3_REMIX:
		SceneTransition.set_vertical_bars(0.0)
		add_child(NETZ_REMIX_MUSIC_INTERACT.instantiate())
		Global.custom_intro = Global.CustomIntros.NONE
	else:
		var music_keys = menu_music.keys()
		var random_key = music_keys[randi() % music_keys.size()]
		Debug.dprint(self, "Last Menu Track: " + Settings.last_played_menu_theme)
		Debug.dprint(self, "Random Theme key: " + random_key)
		
		if Settings.last_played_menu_theme == random_key:
			random_key = music_keys[randi() % music_keys.size()]
			Debug.dprint(self, "Repeat Track. Rerolling Random Theme key: " + random_key)
		
		Settings.last_played_menu_theme = random_key
		Settings.save_settings()
		var random_music = load(menu_music[random_key][0])
		
		random_music.loop = true
		music_player.stream = random_music
		
		if random_key == "ANNOYING_PROPHECY":
			title_shadered.visible = false
			title_dog.visible = true
		
		if menu_music[random_key].size() == 3:
			music_player.volume_db = menu_music[random_key][2]
			music_player.play(menu_music[random_key][1])
		elif menu_music[random_key].size() == 2:
			music_player.play(menu_music[random_key][1])
		else:
			music_player.play()
	


func tween_screen_tint_to(alpha: float) -> void:
	var tween = create_tween()
	tween.tween_property(screen_tint, "color", Color(0.0, 0.0, 0.0, alpha / 255), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	


func set_buttons_enabled(state: bool) -> void:
	for b in button_manager.get_children():
		if b is HoverButton:
			b.visible = state
	fake_buttons.visible = !state


func _on_quit_pressed() -> void:
	tween_screen_tint_to(255)
	await create_tween().tween_method(
		func(vol): AudioServer.set_bus_volume_linear(1, vol),
		AudioServer.get_bus_volume_linear(1),
		0.0,
		1.0
	).finished
	get_tree().call_deferred("quit")


func _on_start_pressed() -> void:
	DeltaWindowsLayer.new_game_prompt.window_popup(true)
	tween_screen_tint_to(125)
	SceneTransition.animate_vertical_bars(100.0, 1.0)
	set_buttons_enabled(false)
	

func _on_new_game_prompt_close_requested() -> void:
	tween_screen_tint_to(0.0)
	SceneTransition.animate_vertical_bars(0.0, 1.0)
	set_buttons_enabled(true)
	DeltaWindowsLayer.new_game_prompt.window_hide()
	back_sfx_player.play()


func _on_credits_pressed() -> void:
	SceneTransition.transition_to_scene("res://Scenes/credits.tscn")

func _on_license_pressed() -> void:
	DeltaWindowsLayer.license_window.window_popup(true)
	tween_screen_tint_to(125)
	SceneTransition.animate_vertical_bars(100.0, 1.0)
	set_buttons_enabled(false)


func _on_settings_pressed() -> void:
	Settings.show_settings_window()
	tween_screen_tint_to(125.0)
	SceneTransition.animate_vertical_bars(100.0, 1.0)
	set_buttons_enabled(false)
	


func _on_main_menu_settings_close_requested() -> void:
	tween_screen_tint_to(0.0)
	SceneTransition.animate_vertical_bars(0.0, 1.0)
	set_buttons_enabled(true)
	Settings.hide_settings_window()


func _on_new_game_prompt_new_game_requested() -> void:
	SceneTransition.transition_to_scene(GAME)
	DeltaWindowsLayer.new_game_prompt.window_hide()
	


func _on_license_window_close_requested() -> void:
	DeltaWindowsLayer.license_window.window_hide()
	tween_screen_tint_to(0.0)
	SceneTransition.animate_vertical_bars(0.0, 1.0)
	set_buttons_enabled(true)
	back_sfx_player.play()
