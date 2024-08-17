extends Node2D

@onready var player: Player = $Player
@onready var ui_animation_player: AnimationPlayer = $UI/AnimationPlayer

@export var required_min_window_size: Vector2i = Vector2i.ZERO

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#181425"))
	get_tree().root.min_size = required_min_window_size
	
	player.player_death.connect(_on_player_death)
	ui_animation_player.play("start")

func _on_player_death():
	ui_animation_player.play("defeat")

func _reload_scene():
	get_tree().reload_current_scene()
