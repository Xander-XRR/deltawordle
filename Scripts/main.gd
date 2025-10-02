extends Control


@onready var soul: Soul = $Soul
@onready var screen_tint: ColorRect = $ScreenTint
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var select_sfx_player: AudioStreamPlayer = $SelectSFXPlayer
@onready var title_dog: Sprite2D = $TitleDog
@onready var title_shadered: Sprite2D = $TitleShadered
@onready var button_manager: Node = $ButtonManager
@onready var fake_buttons: Node2D = $FakeButtons
@onready var new_game_prompt: DeltaWindow = $NewGamePrompt

const GAME = preload("uid://cysny571dnqgg")

# Menu Music [file path, starting point, volume (DB)]
var menu_music: Dictionary = {
	ALT_CHURCH_LOBBY = [preload("uid://cs60e63rlya3j")],
	ANNOYING_PROPHECY = [preload("uid://c1lvmqshi2rpj")],
	AUDIO_ANOTHERHIM = [preload("uid://b6cavfejrhojr")],
	AUDIO_STORY = [preload("uid://byi7m8udftbef")],
	CH_4_CREDITS = [preload("uid://cynapqn2nlogk"), 15.15, 2],
	CHURCH_ZONE_3 = [preload("uid://dkd0sddl1rdkx"), 25.4, 6],
	DOGCHECK = [preload("uid://jc7fg0aws3ip")],
	KRIS_PIANO_WAITINGROOM = [preload("uid://b40lulffh516v")],
	MENU = [preload("uid://p8j7papjwu8k")],
	NOELLE = [preload("uid://bldo0nm3rb01e")],
	QUIET_AUTUMN = [preload("uid://0x3qoj0ikqty")],
	QUIET_CHURCH = [preload("uid://ihwyxro3qhtp")],
	SECOND_CHURCH = [preload("uid://iy303eny0xwk"),  25.4, 6],
	SHOP_1 = [preload("uid://csh7dbuppdd6c")],
	THE_HOLY = [preload("uid://7wotfb3vu4ft")],
	TOWN = [preload("uid://by77462xa8onh")]
}


func _ready() -> void:
	$ButtonManager/Start.grab_focus()
	
	new_game_prompt.new_game_requested.connect(_on_new_game_load_request)
	
	var music_keys = menu_music.keys()
	var random_key = music_keys[randi() % music_keys.size()]
	print("Last Menu Track: " + Settings.last_played_menu_theme)
	print("Random Theme key: " + random_key)
	if Settings.last_played_menu_theme == random_key:
		random_key = music_keys[randi() % music_keys.size()]
		print("Repeat Track. Rerolling Random Theme key: " + random_key)
	
	Settings.last_played_menu_theme = random_key
	Settings.save_settings()
	var random_music = menu_music[random_key][0]
	
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
	new_game_prompt.window_popup(true)
	tween_screen_tint_to(125)
	SceneTransition.animate_vertical_bars(100.0, 1.0)
	set_buttons_enabled(false)
	

func _on_new_game_prompt_close_requested() -> void:
	tween_screen_tint_to(0.0)
	SceneTransition.animate_vertical_bars(0.0, 1.0)
	set_buttons_enabled(true)
	new_game_prompt.window_hide()
	select_sfx_player.play()

func _on_new_game_load_request() -> void:
	SceneTransition.transition_to_scene(GAME)
	new_game_prompt.z_index = 2
	soul.z_index = 2
	


func _on_credits_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("res://README.txt"))

func _on_license_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("res://LICENSE"))


func _on_settings_pressed() -> void:
	%MainMenuSettings.window_popup(true)
	tween_screen_tint_to(125.0)
	SceneTransition.animate_vertical_bars(100.0, 1.0)
	set_buttons_enabled(false)
	

func _on_settings_close_requested() -> void:
	tween_screen_tint_to(0.0)
	SceneTransition.animate_vertical_bars(0.0, 1.0)
	set_buttons_enabled(true)
	%MainMenuSettings.window_hide()
	
