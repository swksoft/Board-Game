extends TileMap

func _process(delta):
	if get_used_cells(3).size() != 0:
		erase_cell(3, get_used_cells(3)[0])
	
	var current_tile = local_to_map(get_global_mouse_position())
	var tile_data : TileData = get_cell_tile_data(1, current_tile)
	if tile_data != null:
		var is_square = tile_data.get_custom_data("Square")
		if is_square:
			set_cell(3, current_tile, 0, Vector2(2,50), 0)
	
