extends Control


@onready var soul: Soul = $Soul
@onready var screen_tint: Sprite2D = $ScreenTint
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var title_dog: Sprite2D = $TitleDog
@onready var title_shadered: Sprite2D = $TitleShadered

# Menu Music
var menu_music: Dictionary = {
	ALT_CHURCH_LOBBY = ["res://Assets/Audio/Music/alt_church_lobby.ogg"],
	ANNOYING_PROPHECY = ["res://Assets/Audio/Music/annoying_prophecy.ogg"],
	AUDIO_ANOTHERHIM = ["res://Assets/Audio/Music/AUDIO_ANOTHERHIM.ogg"],
	AUDIO_STORY = ["res://Assets/Audio/Music/AUDIO_STORY.ogg"],
	CH_4_CREDITS = ["res://Assets/Audio/Music/ch4_credits.ogg"],
	CHURCH_ZONE_3 = ["res://Assets/Audio/Music/church_zone3.ogg", 25.4],
	DOGCHECK = ["res://Assets/Audio/Music/dogcheck.ogg"],
	KRIS_PIANO_WAITINGROOM = ["res://Assets/Audio/Music/kris_piano_waitingroom.ogg"],
	MENU = ["res://Assets/Audio/Music/menu.ogg"],
	NOELLE = ["res://Assets/Audio/Music/noelle.ogg"],
	QUIET_AUTUMN = ["res://Assets/Audio/Music/quiet_autumn.ogg"],
	QUIET_CHURCH = ["res://Assets/Audio/Music/quiet_church.ogg"],
	SECOND_CHURCH = ["res://Assets/Audio/Music/second_church.ogg",  25.4],
	SHOP_1 = ["res://Assets/Audio/Music/shop1.ogg"],
	THE_HOLY = ["res://Assets/Audio/Music/THE_HOLY.ogg"],
	TOWN = ["res://Assets/Audio/Music/town.ogg"]
}

# SECRET DO NOT COUNT
const NORTHERNLIGHT = preload("uid://leqsh2wn672g")


func _ready() -> void:
	$Button_Manager/Start.grab_focus()
	
	var music_keys = menu_music.keys()
	var random_key = music_keys[randi() % music_keys.size()]
	print("Last Menu Track: " + Settings.last_played_menu_theme)
	print("Random Theme key: " + random_key)
	if Settings.last_played_menu_theme == random_key:
		random_key = music_keys[randi() % music_keys.size()]
		print("Repeat Track. Rerolling Random Theme key: " + random_key)
	
	Settings.last_played_menu_theme = random_key
	Settings.save_settings()
	var random_music = AudioStreamOggVorbis.load_from_file(menu_music[random_key][0])
	
	random_music.loop = true
	music_player.stream = random_music
	
	if random_key == "ANNOYING_PROPHECY":
		title_shadered.visible = false
		title_dog.visible = true
	
	if menu_music[random_key].size() >= 2:
		music_player.play(menu_music[random_key][1])
	else:
		music_player.play()
	


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	$NewGamePrompt.popup_centered()
	screen_tint.visible = true

func _on_new_game_prompt_close_requested() -> void:
	screen_tint.visible = false


func _on_credits_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("res://README.txt"))

func _on_license_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("res://LICENSE.txt"))


func _on_settings_pressed() -> void:
	%MainMenuSettings.popup_centered()
	screen_tint.visible = true

func _on_settings_close_requested() -> void:
	screen_tint.visible = false
