extends Node2D

var movement = 1
var grid_size = 32

var mouse_inside_area = false

var panel_layer = 1

@onready var tile_map = get_parent().get_node("TileMap")

func _ready():
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	print(current_tile)

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
		print(target_tile)
		position = tile_map.map_to_local(target_tile)

func _on_area_2d_mouse_entered():
	mouse_inside_area = true

func _on_area_2d_mouse_exited():
	mouse_inside_area = false
