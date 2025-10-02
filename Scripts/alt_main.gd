extends Control


@onready var descriptions: Label = $Descriptions
@onready var start: RichTextButton = $Start
@onready var settings: RichTextButton = $Settings
@onready var credits: RichTextButton = $Credits
@onready var license: RichTextButton = $License
@onready var quit: RichTextButton = $Quit
@onready var background_fade: ColorRect = $BackgroundFade
@onready var alt_menu_settings: SettingsWindows = $AltMenuSettings
@onready var new_game_prompt: Panel = $AltNewGamePrompt

const DELTARUNE_BATTLE_BOX_STYLE = preload("uid://d2syknyok7j2h")


func _ready() -> void:
	SceneTransition.animate_vertical_bars(0.0, 0.01)
	start.unhovered.connect(_no_hovered)
	settings.unhovered.connect(_no_hovered)
	credits.unhovered.connect(_no_hovered)
	license.unhovered.connect(_no_hovered)
	quit.unhovered.connect(_no_hovered)
	
	for child in new_game_prompt.get_children(true):
		if child.has_method("add_theme_stylebox_override"):
			child.add_theme_stylebox_override("style", DELTARUNE_BATTLE_BOX_STYLE)
	
	Settings.save_single_setting("encountered_experiment", true)
	


func _on_start_pressed() -> void:
	new_game_prompt.visible = true
	background_fade.visible = true
	

func _on_start_hovered() -> void:
	descriptions.text = "BEGIN EXPERIMENT."

func _on_new_game_prompt_close_requested() -> void:
	background_fade.visible = false


func _on_settings_pressed() -> void:
	alt_menu_settings.visible = true
	background_fade.visible = true

func _on_settings_hovered() -> void:
	descriptions.text = "CUSTOMIZE APPLICATION."

func _on_alt_menu_settings_close_requested() -> void:
	background_fade.visible = false


func _on_credits_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("res://README.txt"))

func _on_credits_hovered() -> void:
	descriptions.text = "PERCEIVE THE ONES WHO MADE THIS POSSIBLE."


func _on_license_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("res://LICENSE"))

func _on_license_hovered() -> void:
	descriptions.text = "ACKNOWLEDGE THE TERMS AND SERVICE OF THIS EXPERIMENT."


func _on_quit_pressed() -> void:
	if randi() % 2 == 1:
		$ThankYou.visible = true
		await get_tree().create_timer(5.0).timeout
	get_tree().call_deferred("quit")

func _on_quit_hovered() -> void:
	descriptions.text = "END THE CURRENT SESSION."


func _no_hovered() -> void:
	descriptions.text = ""
