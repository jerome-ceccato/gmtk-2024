extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 300
var last_direction: Vector2 = Vector2.DOWN

func _physics_process(delta: float) -> void:
	var movement_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	if not movement_direction.is_zero_approx():
		last_direction = movement_direction
	velocity = movement_direction * speed
	move_and_slide()
	
	animated_sprite.play(get_current_animation_name(movement_direction))

func get_current_animation_name(direction: Vector2) -> String:
	if direction.is_zero_approx():
		return "idle-%s" % get_main_direction_suffix(last_direction)
	else:
		return "run-%s" % get_main_direction_suffix(direction)  
	
func get_main_direction_suffix(dir: Vector2) -> String:
	if dir.x > 0.1:
		return "right"
	elif dir.x < -0.1:
		return "left"
	elif dir.y < -0.1:
		return "up"
	else:
		return "down"
