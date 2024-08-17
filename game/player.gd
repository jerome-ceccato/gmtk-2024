extends CharacterBody2D

@export var speed: float = 300

func _physics_process(delta: float) -> void:
	var movement_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	velocity = movement_direction * speed
	move_and_slide()
