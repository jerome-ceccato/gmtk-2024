extends Node2D

const cell_size: Vector2 = Vector2(16, 16)

func _ready() -> void:
	resize_full()
	get_tree().root.size_changed.connect(resize_full)

func resize_full():
	var bounds := get_map_bounds()
	var target_scale := get_map_scale(bounds)
	
	print(bounds, target_scale)
	position = -(bounds.position * target_scale)
	scale = target_scale

func get_map_bounds() -> Rect2:
	var bounds := Rect2(10000, 10000, 0, 0)
	for child: TileMapLayer in get_children():
		# Get the tilemap pos and convert to global position
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
