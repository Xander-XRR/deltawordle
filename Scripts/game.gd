extends Control


@onready var row_container: Node2D = $RowContainer
@onready var input: Label = $InputText
@onready var letter_container: VBoxContainer = $Keyboard/LetterContainer
@onready var sfx_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var settings: DeltaWindow = $Settings
@onready var win_loose_screen: DeltaWindow = $WinLooseScreen
@onready var soul: Soul = $Soul
@onready var menu_fade: ColorRect = $MenuFade

@export var word_lenght: int = 5

const LETTER_DISPLAY = preload("uid://bxs6e521xet4b")

const SND_GRAZE = preload("res://Assets/Audio/SFX/snd_graze.wav")
const SND_NOISE = preload("res://Assets/Audio/SFX/snd_noise.wav")
const SND_IMPACT = preload("res://Assets/Audio/SFX/snd_impact.wav")

enum LetterCorrectness { UNUSED, USED, PERFECT }

var possible_words = []
var selected_word: String

var busy: bool = false
var current_row: int = 0

var wrong_word_anim_playing: bool = false


var game_music: Dictionary = {
	FIELDS_OF_HOPES = [preload("uid://dgj8dc4clse3s")],
	FOREST = [preload("uid://bfssxps3n74pj")],
	GIANT_QUEEN_APPEARS = [preload("uid://bdkeppp0mdqsf")],
	MIKE = [preload("uid://dklrct567q5xj")], # Mike, Silk their song.
	PUMPKIN_BOSS = [preload("uid://c8st4n2ot5ihc")], # YOUR MAMA-MIA IS TAKING TOO TOO
	ROUXLS_BATTLE = [preload("uid://bjvaa5okjt8g5")], # Bottom.
	SPAMTON_DANCE = [preload("uid://cw8f3yahldk63")]
}

var keyboard_letters: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Random Music 
	var music_keys = game_music.keys()
	var random_key = music_keys[randi() % music_keys.size()]
	print("Last Game Track: " + Settings.last_played_game_theme)
	print("Random Theme key: " + random_key)
	if Settings.last_played_game_theme == random_key:
		random_key = music_keys[randi() % music_keys.size()]
		print("Repeat Track. Rerolling Random Theme key: " + random_key)
	
	Settings.last_played_game_theme = random_key
	Settings.save_settings()
	var random_music = game_music[random_key][0]
	
	random_music.loop = true
	music_player.stream = random_music
	
	if game_music[random_key].size() >= 2:
		music_player.play(game_music[random_key][1])
	else:
		music_player.play()
	
	word_lenght = Global.word_size
	
	var path = ProjectSettings.globalize_path("res://Possible Words/"+ str(word_lenght) +".txt")
	if not FileAccess.file_exists(path):
		push_error("Possible words file missing: %s" % path)
		possible_words = []
	else:
		var file := FileAccess.open(path, FileAccess.READ)
		if file:
			var text: String = file.get_as_text()
			possible_words = text.split("\n", false)
			file.close()
			print("Possible Words: ", possible_words)
		
		selected_word = possible_words[randi() % possible_words.size()]
		print("Selected Word: ", selected_word)
		
		for row in row_container.get_children():
			if not row:
				continue
			for i in range(word_lenght):
				row.add_child(LETTER_DISPLAY.instantiate())
				if row.name == "Row1":
					row.get_child(i).selected()
	
	for row in letter_container.get_children():
		for letter in row.get_children():
			letter.pressed.connect(add_letter_to_displays)
			letter.is_interactable = true
			
			if letter.displayed_letter.length() == 1:
				keyboard_letters[letter.displayed_letter] = letter
			else:
				letter.custom_minimum_size.x = letter.custom_minimum_size.x * 2
				letter.letter_label.size.x = letter.letter_label.size.x * 2
			
			var soul_magnet = SoulMagnet.new()
			soul_magnet.soul_offset.x = 24.0
			letter.add_child(soul_magnet)
	


func check_if_valid_word() -> void:
	if input.text.length() != word_lenght:
		print("Not enough Characters!")
		await play_invalid_word_anim()
		busy = false
		return
	
	if input.text not in possible_words:
		print("Invalid Word!")
		await play_invalid_word_anim()
		busy = false
		return
	
	await reveal_text_correctness()
	
	if input.text == selected_word:
		win_loose_screen.announce(true, selected_word)
		return
	else:
		current_row += 1
		
		if current_row == 5:
			var tween = create_tween()
			tween.tween_property(music_player, "pitch_scale", 1.15, 0.5)
		
		if current_row > 5:
			win_loose_screen.announce(false, selected_word)
			var tween = create_tween()
			tween.tween_property(music_player, "pitch_scale", 0.85, 0.5)
			return
		
		for c in row_container.get_child(current_row).get_children():
			c.selected()
		input.text = ""
		busy = false
	


func change_characters_to_colors(letters_dict: Dictionary) -> void:
	for letter_display in letters_dict:
		var key_display = keyboard_letters[letter_display.letter_label.text]
		match letters_dict[letter_display]:
			LetterCorrectness.PERFECT:
				key_display.modulate = Color.WEB_GREEN
			LetterCorrectness.USED:
				if key_display.modulate != Color.WEB_GREEN:
					key_display.modulate = Color.YELLOW
			LetterCorrectness.UNUSED:
				key_display.modulate = Color.RED
		


func reveal_text_correctness() -> void:
	var i: int = 0
	var letters_dict = {}
	
	for display in row_container.get_child(current_row).get_children():
		if display.letter_label.text == selected_word[i]:
			display.modulate = Color.WEB_GREEN
			letters_dict[display] = LetterCorrectness.PERFECT
			play_sfx(SND_IMPACT)
		elif display.letter_label.text in selected_word:
			if letters_dict.has(display):
				if letters_dict[display] == LetterCorrectness.PERFECT:
					pass
			display.modulate = Color.YELLOW
			letters_dict[display] = LetterCorrectness.USED
			play_sfx(SND_NOISE)
		else:
			display.modulate = Color.RED
			letters_dict[display] = LetterCorrectness.UNUSED
			play_sfx(SND_GRAZE)
		
		i += 1
		await get_tree().create_timer(0.35).timeout
	change_characters_to_colors(letters_dict)
	


func add_letter_to_displays(letter: String) -> void:
	if letter == "BSP":
		if input.text.length() != 0:
			input.text = input.text.erase(input.text.length() - 1)
			add_or_remove_display_letter("")
		return
	if letter == "ENT":
		if busy:
			return
		busy = true
		check_if_valid_word()
		return
	
	if input.text.length() < word_lenght:
		input.text += letter
		add_or_remove_display_letter(letter)
		print("added letter: ", letter)
	else:
		play_invalid_word_anim()
	


func add_or_remove_display_letter(letter: String) -> void:
	if letter != "":
		row_container.get_child(current_row).get_child(input.text.length() - 1).letter_label.text = letter
	else:
		row_container.get_child(current_row).get_child(input.text.length()).letter_label.text = ""
	
	


func play_sfx(sfx) -> void:
	if sfx:
		sfx_player.stream = sfx
		sfx_player.play()
		


func play_invalid_word_anim() -> void:
	if !wrong_word_anim_playing:
		wrong_word_anim_playing = true
		
		var row = row_container.get_child(current_row)
		var origin = row.position.x
		var time = 0.5
		
		$HurtPlayer.play()
		
		while time > 0.0:
			time -= get_process_delta_time()
			row.position.x = origin + sin(time * 70.0) * time * 30.0
			await get_tree().process_frame
		
		row.position.x = origin
		wrong_word_anim_playing = false
	


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and !event.is_echo():
		var c := char(event.unicode).to_upper()
		if c >= "A" and c <= "Z":
			if input.text.length() < word_lenght and !busy:
				input.text += c
				add_or_remove_display_letter(c)
		elif event.keycode == KEY_BACKSPACE:
			if input.text.length() != 0 and !busy:
				input.text = input.text.erase(input.text.length() - 1)
				add_or_remove_display_letter("")
		elif event.keycode == KEY_ENTER:
			if busy:
				return
			busy = true
			check_if_valid_word()
		elif event.keycode == KEY_F3 or event.keycode == KEY_F4:
			pass
		else:
			get_viewport().set_input_as_handled()


func _on_menu_pressed() -> void:
	soul.z_index = 4
	var tween = create_tween()
	tween.tween_property(menu_fade, "color", Color(0.0, 0.0, 0.0, 0.392), 0.5)
	menu_fade.mouse_filter = Control.MOUSE_FILTER_STOP
	settings.window_popup(true)


func _on_settings_close_requested() -> void:
	soul.z_index = 1
	var tween = create_tween()
	tween.tween_property(menu_fade, "color", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	menu_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	settings.window_hide()
