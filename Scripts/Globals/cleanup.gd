extends Node


func _exit_tree() -> void:
	for tween in get_tree().get_processed_tweens():
		tween.kill()
	
