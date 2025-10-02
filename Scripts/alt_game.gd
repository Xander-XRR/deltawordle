extends ColorRect


@onready var hint_label: Label = $Other/Hint
@onready var input_field: LineEdit = $Other/InputField

var words: Dictionary = {
	"DESS": "THE WIELDER OF THE BAT.",
	"KRIS": "THE VESSEL.",
	"SUSIE": "THE GIRL WITH HOPE CROSSED ON HER HEART.",
	"RALSEI": "THE PRINCE IN THE DARK.",
	"BERDLY": "THE ONE WHO AWAITS THE FATAL SNOW.",
	"NOELLE": "AND THEN THERE WAS THE GIRL.&\nAND THEN THERE WAS THE GIRL.",
	"ERAM": "ARENT YOU HAVING SO MUCH FUN?",
	"MANTLE": "THE ORIGINAL GAME.",
	"TITAN": "A FOUNTAIN WITHIN A FOUNTAIN.",
	"ANGEL": "THE ONE WHO WILL DOOM THE WORLD TO ETERNAL DARKNESS.",
	"ME": "AND WHO MIGHT THE HORROR BE?",
}

var level: int = -1
var current_word: String = ""


func _ready() -> void:
	next_level()


func next_level() -> void:
	if level != 10:
		input_field.self_modulate = Color.TRANSPARENT
		input_field.editable = false
		input_field.text = ""
		level += 1
		
		var keys = words.keys()
		current_word = keys[level]
		
		await type_out_hint(words[current_word])
		
		await get_tree().create_timer(0.5).timeout
		
		var tween = create_tween()
		tween.tween_property(input_field, "self_modulate", Color.WHITE, 0.5)
		await get_tree().create_timer(0.2).timeout
		input_field.editable = true
		input_field.call_deferred("release_focus")
		input_field.call_deferred("grab_focus")
		
	


func type_out_hint(hint: String) -> void:
	hint_label.text = ""
	for letter in hint.length():
		if hint[letter] == "&":
			await get_tree().create_timer(0.5).timeout
			continue
		hint_label.text += hint[letter]
		await get_tree().create_timer(0.05).timeout
	


func _on_input_field_text_submitted(new_text: String) -> void:
	if new_text.to_lower() == current_word.to_lower():
		print("correct")
	else:
		print("false")
	next_level()
