extends Node2D

@onready var player: Player = $Player
@onready var ui_animation_player: AnimationPlayer = $UI/AnimationPlayer
@onready var label: Label = $UI/MessageContainer/Label


@export_category("Scene settings")
@export var level_name: String = ""
@export_file("*.tscn") var next_scene: String
@export var required_min_window_size: Vector2i = Vector2i.ZERO

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#181425"))
	get_tree().root.min_size = required_min_window_size
	
	player.player_death.connect(_on_player_death)
	player.player_win.connect(_on_player_win)
	
	label.text = level_name
	ui_animation_player.play("start")

func _on_player_death():
	ui_animation_player.play("defeat")

func _on_player_win():
	if _has_next_level():
		label.text = "Level complete!"
	else:
		label.text = "Congratulations!\nYou won the game!"
	ui_animation_player.play("victory")

func _reload_scene():
	get_tree().reload_current_scene()

func _play_next_scene():
	if _has_next_level():
		get_tree().change_scene_to_file(next_scene)
	else:
		_load_menu()

func _has_next_level() -> bool:
	return next_scene != null and next_scene.length() > 0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_load_menu()

func _load_menu():
	get_tree().change_scene_to_file("res://menu/menu.tscn")
