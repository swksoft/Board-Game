class_name BoardTile extends TileMap

signal spawn_ready(location)

var select_layer = 3
var panel_layer = 1
var movement_layer = 4
var type_layer = 2
var spawn_point : Vector2i

enum SquareType {
	NONE = 0,
	BATTLE = 1,
	TREASURE = 2,
	DIALOG = 4,
	BLIND = 8,
	EVENT = 16,
	BATTLE_EVENT = 32,
	TRAP = 64,
	STAIRS = 128,
	BOSS = 256,
	ESCAPE = 512,
	LIFE_UP = 1024,
	SPAWN_POINT = 2048
}

func get_panel(current_tile):
	match current_tile:
		"BATTLE":
			pass
		"TREASURE":
			pass
		"DIALOG":
			pass
		"BLIND":
			pass
		"EVENT":
			pass
		"BATTLE_EVENT":
			pass
		"TRAP":
			pass
		"STAIRS":
			pass
		"BOSS":
			pass
		"ESCAPE":
			pass
		"LIFE_UP":
			pass
		"SPAWN_POINT":
			pass
	
	print(current_tile)

func _ready():
	var tile_size = tile_set.tile_size
	var map_size = self.get_used_rect()
	
	for x in range(map_size.position.x, map_size.position.x + map_size.size.x):
		for y in range(map_size.position.y, map_size.position.y + map_size.size.y):
			var tile_data : TileData = get_cell_tile_data(2, Vector2i(x,y))
			var tile_id = self.get_cell_source_id(2, Vector2i(x,y))
			
			if tile_data != null:
				var custom_data = tile_data.get_custom_data("Type")
				if custom_data == 2048:
					spawn_point = Vector2i(x,y)
					emit_signal("spawn_ready", spawn_point)

func _process(_delta):
	if get_used_cells(select_layer).size() != 0:
		erase_cell(select_layer, get_used_cells(select_layer)[0])
	
	var current_tile = local_to_map(get_global_mouse_position())
	var tile_data : TileData = get_cell_tile_data(1, current_tile)
	
	if tile_data:
		var is_square = tile_data.get_custom_data("Square")
		if is_square:
			set_cell(select_layer, current_tile, 0, Vector2(2,50), 0)

func get_available_tiles(group_pos, movement):
	var pos : Vector2i = local_to_map(group_pos)
	var reachable_tiles = []
	var queue = []
	var visited = {}
	
	queue.append([pos, 0])
	visited[pos] = true
	
	var directions = [
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(1, 0) 
	]
	
	while queue.size() > 0:
		var front = queue.pop_front()
		var current_pos = front[0]
		var current_dist = front[1]
		
		if current_dist < movement:
			for direction in directions:
				var new_pos = current_pos + direction
				if not visited.has(new_pos) and is_valid_tile(new_pos):
					queue.append([new_pos, current_dist + 1])
					visited[new_pos] = true
					reachable_tiles.append(new_pos)
	
	return reachable_tiles

func is_valid_tile(tile_position):
	var cell_x = int(tile_position.x)
	var cell_y = int(tile_position.y)
	var tile_data : TileData = get_cell_tile_data(panel_layer, Vector2i(cell_x, cell_y))
	
	if tile_data == null : return false
	
	var is_square = tile_data.get_custom_data("Square")
	
	if is_square:
		return true
	return false

func show_adjacent_tiles(data):
	for tile in data:
		set_cell(movement_layer, tile, 0, Vector2(22,50))

func delete_adjacent_tiles():
	var used_cells = get_used_cells(movement_layer)
	for cell in used_cells:
		erase_cell(movement_layer, cell)

func get_current_tile_type(player_position : Vector2i):
	#var player_position: Vector2i = local_to_map(char_pos)
	var cell_x = int(player_position.x)
	var cell_y = int(player_position.y)
	var tile_data = get_cell_tile_data(type_layer, Vector2i(cell_x, cell_y))
	
	if tile_data and tile_data.get_custom_data("Type"):
		var tile_type_value = tile_data.get_custom_data("Type")
		
		for name in SquareType.keys():
			if SquareType[name] == tile_type_value:
				return name
	
	return "NONE"
