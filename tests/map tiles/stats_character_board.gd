class_name StatsCharacterBoard extends Node

@export_range(0,9) var movement = 1
@export var sprite_node = Sprite2D

var character_data = {}

func set_character_data(data):
	character_data = data
	movement = character_data["agility"]
	update_icon()

func update_icon():
	var icon_path = character_data["icon"]
	
	sprite_node.texture = load(icon_path)
