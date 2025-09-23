extends Control


@onready var row_container: VBoxContainer = $RowContainer
@onready var input: LineEdit = $Input
@onready var letter_container: VBoxContainer = $Keyboard/LetterContainer
@onready var sfx_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var settings: Window = $Settings
@onready var win_loose_screen: Panel = $WinLooseScreen

@export var word_lenght: int = 5

const SINGLE_DISPLAY = preload("res://Scenes/single_display.tscn")

const SND_GRAZE = preload("res://Assets/Audio/SFX/snd_graze.wav")
const SND_NOISE = preload("res://Assets/Audio/SFX/snd_noise.wav")
const SND_IMPACT = preload("res://Assets/Audio/SFX/snd_impact.wav")

var possible_words = []
var selected_word: String

var busy: bool = false
var current_row: int = 0

var game_music: Dictionary = {
	FIELDS_OF_HOPES = ["res://Assets/Audio/Music/field_of_hopes.ogg"],
	FOREST = ["res://Assets/Audio/Music/forest.ogg"],
	GIANT_QUEEN_APPEARS = ["res://Assets/Audio/Music/giant_queen_appears.ogg"],
	MIKE = ["res://Assets/Audio/Music/mike.ogg"], # Mike, Silk their song.
	PUMPKIN_BOSS = ["res://Assets/Audio/Music/pumpkin_boss.ogg"], # YOUR MAMA-MIA IS TAKING TOO TOO
	ROUXLS_BATTLE = ["res://Assets/Audio/Music/rouxls_battle.ogg"], # Bottom.
	SPAMTON_DANCE = ["res://Assets/Audio/Music/spamton_dance.ogg"]
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Random Music 
	var music_keys = game_music.keys()
	var random_key = music_keys[randi() % music_keys.size()]
	print("Last Menu Track: " + Settings.last_played_menu_theme)
	print("Random Theme key: " + random_key)
	if Settings.last_played_menu_theme == random_key:
		random_key = music_keys[randi() % music_keys.size()]
		print("Repeat Track. Rerolling Random Theme key: " + random_key)
	
	Settings.last_played_menu_theme = random_key
	Settings.save_settings()
	var random_music = AudioStreamOggVorbis.load_from_file(game_music[random_key][0])
	
	random_music.loop = true
	music_player.stream = random_music
	
	if game_music[random_key].size() >= 2:
		music_player.play(game_music[random_key][1])
	else:
		music_player.play()
	
	word_lenght = Global.word_size
	
	input.max_length = word_lenght
	
	var file := FileAccess.open("res://Possible Words/"+ str(word_lenght) +".txt", FileAccess.READ)
	if file:
		var text: String = file.get_as_text()
		possible_words = text.split("\n", false)
		file.close()
		print(possible_words)
	
	selected_word = possible_words[randi() % possible_words.size()]
	
	for row in row_container.get_children():
		for i in word_lenght:
			row.add_child(SINGLE_DISPLAY.instantiate())
			if row.name == "Row1":
				row.get_child(i).selected()
	


func check_completion() -> void:
	if input.text.length() != word_lenght:
		print("Not enough Characters!")
		busy = false
		return
	
	if input.text not in possible_words:
		print("Invalid Word!")
		busy = false
		return
	
	input.editable = false
	await reveal_text_correctness()
	
	if input.text == selected_word:
		win_loose_screen.announce(true, selected_word)
		return
	else:
		current_row += 1
		
		if current_row > 5:
			win_loose_screen.announce(false, selected_word)
			return
		
		for c in row_container.get_child(current_row).get_children():
			c.selected()
		input.editable = true
		input.text = ""
		busy = false
	


func change_characters_to_colors(letters_dict: Dictionary) -> void:
	for row in letter_container.get_children():
		for ltr: SingleLetterDisplay in row.get_children():
			var chr: String = ltr.initial_letter
			if chr in letters_dict:
				ltr.set_letter_state(letters_dict[chr])
				
	


func reveal_text_correctness() -> void:
	var i: int = 0
	var letters_dict = {}
	for child in row_container.get_child(current_row).get_children():
		if child.label.text == selected_word[i]:
			child.modulate = Color.WEB_GREEN
			letters_dict[input.text[i]] = 3
			play_sfx(SND_IMPACT)
		elif child.label.text in selected_word:
			child.modulate = Color.YELLOW
			letters_dict[input.text[i]] = 2
			play_sfx(SND_NOISE)
		else:
			child.modulate = Color.RED
			letters_dict[input.text[i]] = 1
			play_sfx(SND_GRAZE)
		
		i += 1
		await get_tree().create_timer(0.35).timeout
	print(letters_dict)
	change_characters_to_colors(letters_dict)
	


func play_sfx(sfx) -> void:
	if sfx:
		sfx_player.stream = sfx
		sfx_player.play()
		


func _process(_delta: float) -> void:
	if current_row < 6:
		input.caret_column = input.text.length()
		for child in row_container.get_child(current_row).get_children():
			child.label.text = ""
		
		if input.text != "":
			for i in input.text.length():
				var child = row_container.get_child(current_row).get_child(i)
				child.label.text = input.text[i]
	


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and !event.is_echo():
		var c := char(event.unicode).to_upper()
		if c >= "A" and c <= "Z":
			input.text += c
		elif event.keycode == KEY_BACKSPACE:
			input.text = input.text.erase(input.text.length() - 1)
		elif event.keycode == KEY_ENTER:
			if busy:
				return
			busy = true
			check_completion()
		else:
			get_viewport().set_input_as_handled()


func _on_input_text_changed(new_text: String) -> void:
	input.text = new_text.to_upper()
	input.caret_column = new_text.length()


func _on_input_text_submitted(_new_text: String) -> void:
	await get_tree().process_frame
	input.call_deferred("grab_focus")
	input.call_deferred("grab_click_focus")


func _on_menu_pressed() -> void:
	settings.popup_centered()
