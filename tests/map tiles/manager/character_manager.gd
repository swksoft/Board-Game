extends Node2D

@export var tile_map_path : BoardTile

var characters = []
var selected_characters = []

func _ready():
	# Load Characters
	var available_characters = GlobalDataTest.available_characters
	
	for char_data in available_characters:
		var char_instance = preload("res://tests/map tiles/character_test.tscn").instantiate()
		
		
		char_instance.tile_map_path = tile_map_path
		char_instance.spawn_point = tile_map_path.spawn_point
		characters.append(char_instance)
		add_child(char_instance)
		char_instance.stats_board.set_character_data(char_data)
