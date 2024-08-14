extends Node2D

@export var tile_map_path : BoardTile

var characters = []
var positions = {}

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
	
	# Load Characters
	var available_characters = GlobalDataTest.available_characters
	var number = 0
	
	for char_data in available_characters:
		var char_instance = preload("res://tests/map tiles/character_test.tscn").instantiate()
		
		char_instance.tile_map_path = tile_map_path
		char_instance.spawn_point = tile_map_path.spawn_point
		characters.append(char_instance)
		char_instance.name = str(char_data["name"])
		add_child(char_instance)
		char_instance.stats_board.set_character_data(char_data)
	find_groups()
	
func on_character_moved(character: CharacterBoard, move_in_group, from):
	if move_in_group:
		for position in positions:
			if position == from:
				for char in positions[position].chars:
					char.global_position = character.global_position
	find_groups()

func _on_group_options_move_entire_group(chars):
	var average_movement = 0
	var sum = 0
	
	for char in chars:
		char.can_move = true
		sum += char.stats_board.movement
	
	average_movement = (sum / chars.size()) - chars.size()
	if average_movement <= 1:
		average_movement = 1
	
	tile_map_path.show_adjacent_tiles(tile_map_path.get_available_tiles(chars[0].global_position, average_movement))

func _on_group_options_move_group(char):
	for child in get_children().size():
		var char_name = get_child(child) as CharacterBoard
		
		if str(char_name) == str(char):
			char_name.can_move = true
			char_name.show_adjacent_tiles(char_name.get_available_tiles())
