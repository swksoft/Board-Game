extends TileMap

var select_layer = 3

func _process(_delta):
	if get_used_cells(select_layer).size() != 0:
		erase_cell(select_layer, get_used_cells(select_layer)[0])
	
	var current_tile = local_to_map(get_global_mouse_position())
	var tile_data : TileData = get_cell_tile_data(1, current_tile)
	
	if tile_data:
		var is_square = tile_data.get_custom_data("Square")
		if is_square:
			set_cell(select_layer, current_tile, 0, Vector2(2,50), 0)
			
		
	
