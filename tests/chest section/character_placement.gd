extends Node2D

@export var chest_manager : ChestManager
@export var character_scene : PackedScene

func _on_chest_manager_load_data():
	var current_point = 1
	
	for character in chest_manager.characters:
		var location = "Point%d" % current_point
		var instance = character_scene.instantiate()
		
		if has_node("Point1"):
			print("ajpo")
		
		if has_node(location):
			get_node(location).add_child(instance)
			#instance.init(character_scene)
		else:
			print("path invalido")
		current_point += 1
