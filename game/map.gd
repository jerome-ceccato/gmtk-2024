extends Node2D

@export var player: Player

const cell_size: Vector2 = Vector2(16, 16)

func _ready() -> void:
	resize_map_and_adjust_player()
	get_tree().root.size_changed.connect(on_window_size_changed)

func resize_map_and_adjust_player():
	var local_player_pos = to_local(player.global_position)
	resize_full()
	player.global_position = to_global(local_player_pos)

func resize_full():
	var bounds := get_map_bounds()
	var target_scale := get_map_scale(bounds)
	
	# Keep the 1:1 ratio
	var effective_scale := Vector2(
		min(target_scale.x, target_scale.y), 
		min(target_scale.x, target_scale.y)
	)
	
	# Center the board
	var position_correction := Vector2(
		((bounds.size.x * target_scale.x) - (bounds.size.x * effective_scale.x)) / 2.0,
		((bounds.size.y * target_scale.y) - (bounds.size.y * effective_scale.y)) / 2.0,
	)
	
	position = -(bounds.position * target_scale) + position_correction
	scale = effective_scale

func get_map_bounds() -> Rect2:
	var bounds := Rect2(10000, 10000, 0, 0)
	for node: Node in get_children():
		if node is not TileMapLayer:
			continue
		# Get the tilemap pos and convert to global position
		# Add 1 tile padding around
		var child := node as TileMapLayer
		var other_map_bounds := child.get_used_rect()
		var other_pos = child.map_to_local(other_map_bounds.position)
		var other_end = child.map_to_local(other_map_bounds.end)
		
		# Take the max bounding box, taking into account that positions are center of tiles, so adjusting by cell size
		bounds.position.x = min(bounds.position.x, other_pos.x - (cell_size.x / 2))
		bounds.position.y = min(bounds.position.y, other_pos.y - (cell_size.y / 2))
		bounds.end.x = max(bounds.end.x, other_end.x - (cell_size.x / 2))
		bounds.end.y = max(bounds.end.y, other_end.y - (cell_size.y / 2))
	return bounds

func get_map_scale(bounds: Rect2) -> Vector2:
	var window_size := Vector2(get_tree().root.size)
	return Vector2(window_size.x / bounds.size.x, window_size.y / bounds.size.y)

func on_window_size_changed():
	resize_map_and_adjust_player()
