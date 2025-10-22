extends Node2D


@onready var label: RichTextLabel = $Label
var desc_list: Array = [
	"[font_size=20][i][color=gray]I'm gonna splode :3c[/color][/i][/font_size]\
	\nProgrammer and Dev.\
	\nNot much else say other than thanks for playing!\
	\n\n(PS: Press enter when reading a credit you're interested in!)",
	
	"[font_size=20][i][color=gray]Bark bark![/color][/i][/font_size]\
	\nThe Creator of UNDERTALE and DELTARUNE.\
	\nWithout him this project would'nt have ever existed.\
	\nGo play UNDERTALE and DELTARUNE, they're genuinely so peak.",
	
	"[font_size=20][i][color=gray]i really thirded my sanctuary with that one[/color][/i][/font_size]\
	\nCreated that one awesome Remix of the Third Sanctuary.\
	\nIn fucking Ultrabox.\
	\nWaow.",
	
	"Return to Main Menu"
]
var revealing_desc = false

func _ready() -> void:
	label.text = desc_list[0]
	reveal_desc()


func reveal_desc() -> void:
	label.visible_characters = 0
	if revealing_desc:
		return
	
	revealing_desc = true
	
	while label.visible_characters < label.text.length():
		label.visible_characters += 1
		await get_tree().create_timer(0.01).timeout
	
	revealing_desc = false


func _on_names_new_selected(index: int) -> void:
	label.text = desc_list[index]
	reveal_desc()
