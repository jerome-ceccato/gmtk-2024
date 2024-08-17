class_name Player
extends CharacterBody2D

signal player_death()
signal player_win()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var floor_detector: Area2D = $FloorDetector

@export var speed: float = 300
var last_direction: Vector2 = Vector2.DOWN

var _on_floor = false
var _alive = true

var coins: int = 0

func _physics_process(delta: float) -> void:
	if not _alive:
		return
	
	var movement_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	if not movement_direction.is_zero_approx():
		last_direction = movement_direction
	velocity = movement_direction * speed
	move_and_slide()
	
	animated_sprite.play(_get_current_animation_name(movement_direction))
	_check_floor()

func _check_floor():
	# _on_floor helps ignore the first instances where the floor is not detected yet
	# Falls only happen if you've been on the floor before
	if floor_detector.get_overlapping_bodies().size() == 0:
		if _on_floor:
			kill_fall()
	else:
		_on_floor = true

func _get_current_animation_name(direction: Vector2) -> String:
	if direction.is_zero_approx():
		return "idle-%s" % _get_main_direction_suffix(last_direction)
	else:
		return "run-%s" % _get_main_direction_suffix(direction)  
	
func _get_main_direction_suffix(dir: Vector2) -> String:
	if dir.x > 0.1:
		return "right"
	elif dir.x < -0.1:
		return "left"
	elif dir.y < -0.1:
		return "up"
	else:
		return "down"

func kill_fall():
	if not _alive:
		return
	
	_alive = false
	animation_player.play("death-fall")

func exit_level():
	if not _alive:
		return
	
	_alive = false
	animation_player.play("exit-level")

func on_death():
	player_death.emit()

func on_win():
	player_win.emit()

func pickup_coin():
	coins += 1
