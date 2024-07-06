@icon("res://icons/logo_godot.svg")
extends Node2D

@export_range(0,9) var movement = 1

var grid_size = 32

var mouse_inside_area = false

var panel_layer = 1
var movement_layer = 4

@onready var tile_map = get_parent().get_node("TileMap") as TileMap

func _ready():
	show_adjacent_tiles(get_adjacent_tiles())
	
func show_adjacent_tiles(data):
	for tile in data:
		tile_map.set_cell(movement_layer, tile, 0, Vector2(22,50))

func delete_adjacent_tiles(data):
	for tile in data:
		tile_map.erase_cell(movement_layer, tile)

func get_adjacent_tiles():
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var adjacent_tiles = []
	
	for x in range(-movement, movement + 1):
		for y in range(-movement, movement + 1):
			if x == 0 and y == 0:
				continue
			
			if abs(x) + abs(y) <= movement:
				var adjacent_tile = current_tile + Vector2i(x, y)
				
				if is_valid_tile(adjacent_tile):
					adjacent_tiles.append(adjacent_tile)
	
	return adjacent_tiles

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
			print_debug("Character Clicked")

func _input(event):
	var target_tile = tile_map.local_to_map(get_global_mouse_position())
	var tile_data: TileData = tile_map.get_cell_tile_data(panel_layer, target_tile)
	if tile_data == null: return
	
	var is_walkable = tile_data.get_custom_data("Square")
	
	if Input.is_action_just_pressed("click") and is_walkable:
		delete_adjacent_tiles(get_adjacent_tiles())
		position = tile_map.map_to_local(target_tile)
		
		get_adjacent_tiles() # DEBUG
		show_adjacent_tiles(get_adjacent_tiles())

func _on_area_2d_mouse_entered():
	mouse_inside_area = true

func _on_area_2d_mouse_exited():
	mouse_inside_area = false
