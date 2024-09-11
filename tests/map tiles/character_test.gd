@icon("res://icons/icon_happy.svg")
class_name CharacterBoard extends Node2D

@export var stats_board : StatsCharacterBoard

var character_manager : CharacterManagerBoard
var tile_map : BoardTile
var mouse_inside_area = false
var can_move = false
var spawn_point : Vector2i
var current_position : Vector2i

var moved_character = false
var moved_group = false

func _ready():
	EventsTest.grouped_character.connect(on_grouped_char)
	EventsTest.end_turn_board.connect(on_new_turn)
	#character_manager = get_tree().get_first_node_in_group("character_manager") # QUEEEE

func on_new_turn():
	modulate = Color("#ffffffff")
	moved_character = false

func _process(_delta):
	if mouse_inside_area:
		if Input.is_action_just_pressed("click"):
			if moved_character == true:
				EventsTest.emit_board_message_display(name + "ya se ha movido.")
				return
			if character_manager.in_group == true:
				EventsTest.emit_grouped_character(self)
			else:
				if can_move:
					can_move = false
					tile_map.delete_adjacent_tiles()
				else:
					can_move = true
					tile_map.show_adjacent_tiles(tile_map.get_available_tiles(position, stats_board.movement))
		elif Input.is_action_just_pressed("right_click"):
			can_move = false
			tile_map.delete_adjacent_tiles()

func _input(event):
	if can_move && !character_manager.selecting_character:
		var target_tile = tile_map.local_to_map(get_global_mouse_position())
		var tile_data: TileData = tile_map.get_cell_tile_data(tile_map.movement_layer, target_tile)
		if tile_data == null: return
		
		var is_walkable = tile_data.get_custom_data("CanMove")
		
		if Input.is_action_just_pressed("click") and is_walkable and moved_character == false and !character_manager.char_moving:
			character_manager.move(self, target_tile)

func arrival():
	moved_character = true
	modulate = Color("#ffffff70")

func move(path):
	character_manager.char_moving = true
	for tile in path:
		await get_tree().create_timer(0.1).timeout
		position = tile_map.map_to_local(tile)
	character_manager.char_moving = false

func enter_group(n):
	var i = n + 1
	var y = -16
	var x = -40
	if i > 2:
		x = -40
		y = 16
		i -= 2
	x += 20 * i
		
	character_manager.in_group = true
	$Sprite2D.scale = Vector2(0.5, 0.5)
	$Sprite2D.offset = Vector2(x, y)
	
func leave_group():
	character_manager.in_group = false
	$Sprite2D.offset = Vector2(0, 0)
	$Sprite2D.scale = Vector2(1, 1)

func _on_area_2d_mouse_entered():
	#printerr("Input al jugador")
	mouse_inside_area = true

func _on_area_2d_mouse_exited():
	mouse_inside_area = false

func on_grouped_char(_char):
	tile_map.delete_adjacent_tiles()
