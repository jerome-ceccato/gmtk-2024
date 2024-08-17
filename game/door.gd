extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_key_pickup():
	animated_sprite.play("open")
	collision_shape.queue_free()
