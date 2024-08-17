extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

var _available = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and _available:
		_available = false
		animation_player.play("pickup")
		(body as Player).pickup_coin()
