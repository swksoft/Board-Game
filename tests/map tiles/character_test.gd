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
var in_group = false
var priority = 1

@onready var tile_map = tile_map_path as TileMap

func _ready():
	#$Area2D.priority = priority
	#$Area2D.collision_layer = priority
	EventsTest.grouped_character.connect(on_grouped_char)
	print("El jugador está en un panel de tipo: ", get_current_tile_type())
	position = tile_map.map_to_local(spawn_point)

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

func delete_adjacent_tiles():
	print("borrando in cells")
	var used_cells = tile_map.get_used_cells(movement_layer)
	for cell in used_cells:
		tile_map.erase_cell(movement_layer, cell)

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
			if in_group == true:
				EventsTest.emit_grouped_character(self)
			else:
				if can_move:
					can_move = false
					delete_adjacent_tiles()
				else:	
					can_move = true
					show_adjacent_tiles(get_available_tiles())
		elif Input.is_action_just_pressed("right_click"):
			can_move = false
			delete_adjacent_tiles()

func _input(event):
	if can_move:
		var target_tile = tile_map.local_to_map(get_global_mouse_position())
		var tile_data: TileData = tile_map.get_cell_tile_data(movement_layer, target_tile)
		if tile_data == null: return
		
		var is_walkable = tile_data.get_custom_data("CanMove")
		
		if Input.is_action_just_pressed("click") and is_walkable:
			move(target_tile, false)
		elif Input.is_action_just_pressed("right_click") and is_walkable:
			if in_group: move(target_tile, true)
			else: print("No está en grupo")
			
func move(target_tile, group):
	delete_adjacent_tiles()
	var previous_global = global_position
	position = tile_map.map_to_local(target_tile)
			
	show_adjacent_tiles(get_available_tiles())
			
	current_position = tile_map.local_to_map(position)
	
	EventsTest.emit_character_moved(self, group, previous_global)
	
	EventsTest.emit_board_message_display(stats_board.character_data["name"] + " está en un panel de tipo: " + get_current_tile_type())
	
	get_panel(get_current_tile_type())

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

func enter_group(n):
	var i = n + 1
	var y = -16
	var x = -40
	if i > 2:
		x = -40
		y = 16
		i -= 2
	x += 20 * i
		
	in_group = true
	$Sprite2D.scale = Vector2(0.5, 0.5)
	$Sprite2D.offset = Vector2(x, y)
	
func leave_group():
	in_group = false
	$Sprite2D.offset = Vector2(0, 0)
	$Sprite2D.scale = Vector2(1, 1)

func _on_area_2d_mouse_entered():
	printerr("Input al jugador")
	mouse_inside_area = true

func _on_area_2d_mouse_exited():
	mouse_inside_area = false

func on_grouped_char(_char):
	delete_adjacent_tiles()
