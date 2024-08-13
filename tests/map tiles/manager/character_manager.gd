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
		#positions[char.global_position].chars.push_back(char)
		positions[char.global_position]["chars"].append(char)
		
	for position in positions:
		if positions[position].chars.size() > 1:
			var i = 0
			for char in positions[position].chars:
				var char_name = char.name
				char.enter_group(i)
				i += 1
		else: positions[position].chars[0].leave_group()
	
	#for pos in positions.keys():
		#var chars_at_pos = positions[pos]["chars"]
		#if chars_at_pos.size() > 1:
			#group_characters_at_position(pos, chars_at_pos)
		#else:
			#chars_at_pos[0].leave_group()
#
	print(positions)

func group_characters_at_position(pos, characters_at_pos):
	pass
	#var group_node = Node2D.new()
	#group_node.name = "group"
	#group_node.position = pos
	#
	#var area2d = Area2D.new()
	#var collision_shape = CollisionShape2D.new()
	#var shape = RectangleShape2D.new()
	#shape.extents = Vector2(32, 32)  # Ajusta esto según el tamaño de la casilla
	#collision_shape.shape = shape
	#area2d.add_child(collision_shape)
	#
	#group_node.add_child(area2d)
	#
	#for char in characters_at_pos:
		#char.position -= pos  # Ajusta la posición al nuevo nodo
		##group_node.add_child(char)
		##group_node.move_child(char, group_node)
		#group_node.move_child(char, -1)
	#
	#
	#add_child(group_node)
	#positions.append(group_node)

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
		#char_instance.priority = number + 1
		#break
		
		number += 1
		
	find_groups()
	
func on_character_moved(character: CharacterBoard, move_in_group, from):
	if move_in_group:
		for position in positions:
			if position == from:
				for char in positions[position].chars:
					char.global_position = character.global_position
	find_groups()
