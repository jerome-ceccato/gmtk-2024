extends Area2D

func _physics_process(delta: float) -> void:
	for body: Node2D in get_overlapping_bodies():
		if body is not Player:
			continue
		
		var player := body as Player
		var body_rect_local: Rect2 = player.feet.shape.get_rect()
		var area_rect_local: Rect2 = get_node('CollisionShape2D').shape.get_rect()
		
		var body_rect := Rect2()
		body_rect.position = body.to_global(body_rect_local.position)
		body_rect.end = body.to_global(body_rect_local.end)
		
		var area_rect := Rect2()
		area_rect.position = to_global(area_rect_local.position)
		area_rect.end = to_global(area_rect_local.end)
		
		if area_rect.encloses(body_rect):
			kill_player(player)

func kill_player(player: Player):
	player.kill_fall()
