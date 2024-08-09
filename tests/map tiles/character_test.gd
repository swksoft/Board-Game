@icon("res://icons/icon_happy.svg")
class_name CharacterBoard extends Node2D

@export var tile_map_path : BoardTile
@export var stats_board : StatsCharacterBoard

var mouse_inside_area = false
var panel_layer = 1
var movement_layer = 4
var type_layer = 2
var can_move = false
var spawn_point : Vector2i
var current_position : Vector2i

@onready var tile_map = tile_map_path as TileMap

func _ready():
	print("El jugador está en un panel de tipo: ", get_current_tile_type())
	position = tile_map.map_to_local(spawn_point)
	current_position = tile_map.local_to_map(position)

func get_current_tile_type():
	var player_position: Vector2i = tile_map.local_to_map(global_position)
	var cell_x = int(player_position.x)
	var cell_y = int(player_position.y)
	var tile_data = tile_map.get_cell_tile_data(type_layer, Vector2i(cell_x, cell_y))
	
	if tile_data and tile_data.get_custom_data("Type"):
		var tile_type_value = tile_data.get_custom_data("Type")
		
		# Buscar el nombre del tipo de casilla en el enum del TileMap
		for name in tile_map.SquareType.keys():
			if tile_map.SquareType[name] == tile_type_value:
				return name
	return "NONE"

func show_adjacent_tiles(data):
	for tile in data:
		tile_map.set_cell(movement_layer, tile, 0, Vector2(22,50))

func delete_adjacent_tiles(data):
	for tile in data:
		tile_map.erase_cell(movement_layer, tile)

func get_available_tiles():
	var player_position: Vector2i = tile_map.local_to_map(global_position)
	var reachable_tiles = []
	var queue = []
	var visited = {}
	
	queue.append([player_position, 0])
	visited[player_position] = true
	
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
		
		if current_dist < stats_board.movement:
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
	var tile_data : TileData = tile_map.get_cell_tile_data(panel_layer, Vector2i(cell_x, cell_y))
	
	if tile_data == null : return false
	
	var is_square = tile_data.get_custom_data("Square")
	
	if is_square:
		return true
	return false

func _process(_delta):
	if mouse_inside_area:
		if Input.is_action_just_pressed("click"):
			if can_move:
				can_move = false
				delete_adjacent_tiles(get_available_tiles())
			else:	
				can_move = true
				show_adjacent_tiles(get_available_tiles())
		elif Input.is_action_just_pressed("right_click"):
			can_move = false
			delete_adjacent_tiles(get_available_tiles())
				
	elif Input.is_action_just_pressed("right_click") or Input.is_action_just_pressed("click"):
		can_move = false
		delete_adjacent_tiles(get_available_tiles())

func _input(event):
	if can_move:
		var target_tile = tile_map.local_to_map(get_global_mouse_position())
		var tile_data: TileData = tile_map.get_cell_tile_data(movement_layer, target_tile)
		if tile_data == null: return
		
		var is_walkable = tile_data.get_custom_data("CanMove")
		
		if Input.is_action_just_pressed("click") and is_walkable:
			delete_adjacent_tiles(get_available_tiles())
			position = tile_map.map_to_local(target_tile)
			
			show_adjacent_tiles(get_available_tiles())
			
			#print("El jugador está en un panel de tipo: ", get_current_tile_type())
			current_position = tile_map.local_to_map(position)
			
			EventsTest.emit_character_moved()

func _on_area_2d_mouse_entered():
	mouse_inside_area = true

func _on_area_2d_mouse_exited():
	mouse_inside_area = false
