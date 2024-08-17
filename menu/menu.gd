extends Control

@export_file("*.tscn") var first_level_path: String

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(first_level_path)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
