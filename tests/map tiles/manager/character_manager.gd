extends Node2D

@export var tile_map_path : BoardTile

var characters = []
var group_characters = []
var grouped_characters = {}

func find_groups():
	#group_characters.clear()
	#grouped_characters.clear()
	
	var positions = {}

	for child in self.get_children():
		if child is CharacterBoard:
			var position = tile_map_path.local_to_map(child.global_position)
			#print("Child:", child.name, "Position:", position)
		
			if positions.has(position):
				positions[position].append(child)
			else:
				positions[position] = [child]
		
	for pos in positions:
		if positions[pos].size() > 1:
			group_characters.append(positions[pos])
			grouped_characters[pos] = positions[pos]
			print_debug("Multiple characters at position", pos, ":", positions[pos])

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
	
func on_character_moved():
	find_groups()
