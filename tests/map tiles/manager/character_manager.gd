extends Node2D

@export var tile_map_path : BoardTile

var characters = []
var groups = []

func find_groups():
	#group_characters.clear()
	#grouped_characters.clear()
	groups = []
	var chars = self.get_children()

	for child in chars:
		if !(child is CharacterBoard): continue
		var position = tile_map_path.local_to_map(child.global_position)
		var coincidences = []
		for child2 in chars:
			if child2 == child: continue
			var position2 = tile_map_path.local_to_map(child2.global_position)
			if position != position2: continue
			coincidences.push_back(child2)
			chars.remove_at(chars.find(child2))
		if coincidences.size() > 0:
			coincidences.push_back(child)
			groups.push_back(coincidences)
		chars.remove_at(chars.find(child))


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
	
func on_character_moved(character: CharacterBoard):
	find_groups()
	for group : Array in groups:
		print(group)
		if group.has(character):
			for char in group:
				char.global_position = character.global_position
