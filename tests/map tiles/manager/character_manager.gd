class_name CharacterManagerBoard extends Node2D

@export var tile_map : BoardTile
@export var character_scene : PackedScene

var is_init = false

var characters = []
var positions = {}
var in_group: bool = false
var selecting_character = false
var char_moving = false

func init(char_set):
	characters.clear()
	characters = char_set
	is_init = true
	
func find_groups():
	positions = {}
	
	var chars = self.get_children()
	
	for char in chars:
		if !positions.has(char.global_position): 
			positions[char.global_position] = {
				chars = []
			}
		positions[char.global_position]["chars"].append(char)
		
	for position in positions:
		if positions[position].chars.size() > 1:
			var i = 0
			for char in positions[position].chars:
				var char_name = char.name
				char.enter_group(i)
				i += 1
		else: positions[position].chars[0].leave_group()

func _ready():
	EventsTest.character_moved.connect(on_character_moved)
	
	if is_init == false:
		print("TESTING")

func move(body, target_tile):
	tile_map.delete_adjacent_tiles()
	
	var previous_global = body.global_position
	var current_tile = tile_map.local_to_map(previous_global)
	var available_tiles = tile_map.get_available_tiles(body.position, body.stats_board.movement)
	var shortest_path = A_Star.new().find_shortest_path(current_tile, target_tile, available_tiles)
	
	await body.move(shortest_path)
	
	EventsTest.emit_character_moved(body, in_group, previous_global)
	
	var current_tile_name = tile_map.get_current_tile_type(target_tile)
	
	if current_tile_name != "NONE" or current_tile_name != "SPAWN":
		if in_group:
			EventsTest.emit_board_message_display("El grupo cayó en un panel tipo: " + current_tile_name.to_lower())
		else:
			EventsTest.emit_board_message_display(body.stats_board.character_data["name"] + " cayó en un panel tipo: " + current_tile_name.to_lower())
	
	body.arrival()
	
	# TRIGGER
	tile_map.get_panel(current_tile_name)

func on_character_moved(character: CharacterBoard, move_in_group, from):
	if move_in_group:
		for position in positions:
			if position == from:
				for char in positions[position].chars:
					char.global_position = character.global_position
	find_groups()

func _on_group_options_move_entire_group(chars):
	in_group = true
	var average_movement = 0
	var sum = 0
	
	for char in chars:
		char.can_move = true
		sum += char.stats_board.movement
	
	average_movement = (sum / chars.size()) - chars.size()
	if average_movement <= 1:
		average_movement = 1
	tile_map.show_adjacent_tiles(tile_map.get_available_tiles(chars[0].global_position, average_movement))

func _on_group_options_move_group(char):
	in_group = false
	for child in get_children().size():
		var char_name = get_child(child) as CharacterBoard
		if str(char_name) == str(char):
			char_name.can_move = true
			tile_map.show_adjacent_tiles(tile_map.get_available_tiles(char.global_position, char.stats_board.movement))

func _on_tile_map_spawn_ready(location):
	# Load Characters
	#var available_characters = GlobalDataTest.available_characters
	#var available_characters = characters
	
	for char_data in characters:
		var char_instance = character_scene.instantiate()
		
		char_instance.initialize(char_data)
		char_instance.character_manager = self
		char_instance.spawn_point = location
		char_instance.tile_map = tile_map
		char_instance.position = tile_map.map_to_local(location)
		
		add_child(char_instance)
	
	#for char_data in available_characters:
		#var char_instance = character_scene.instantiate()
		#
		#char_instance.spawn_point = location
		#char_instance.character_manager = self
		##characters.append(char_instance)
		#char_instance.name = str(char_instance["name"])
		##char_instance.stats_board.set_character_data(char_data)
		#char_instance.tile_map = tile_map
		#char_instance.position = tile_map.map_to_local(location)
		
		#add_child(char_instance)

	find_groups()
