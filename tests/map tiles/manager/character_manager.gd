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
		positions[char.global_position].chars.push_back(char)
		
	for position in positions:
		if positions[position].chars.size() > 1:
			var i = 0
			for char in positions[position].chars:
				char.enter_group(i)
				i += 1
		else: positions[position].chars[0].leave_group()


func _ready():
	# Connect character_moved_signal
	EventsTest.character_moved.connect(on_character_moved)
	
	# Load Characters
	var available_characters = GlobalDataTest.available_characters
	var number = 0
	
	for char_data in available_characters:
		var char_instance = preload("res://tests/map tiles/character_test.tscn").instantiate()
		
		char_instance.tile_map_path = tile_map_path
		char_instance.spawn_point = tile_map_path.spawn_point
		characters.append(char_instance)
		char_instance.name = "Char" + str(number)
		add_child(char_instance)
		char_instance.stats_board.set_character_data(char_data)
		
		number += 1
		
	find_groups()
	
func on_character_moved(character: CharacterBoard, move_in_group, from):
	if move_in_group:
		for position in positions:
			if position == from:
				for char in positions[position].chars:
					char.global_position = character.global_position
	find_groups()
