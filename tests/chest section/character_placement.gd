extends Node2D

@export var chest_manager : ChestManager
@export var character_scene : PackedScene

func _on_chest_manager_load_data():
	var current_point = 1
	
	for character in chest_manager.characters:
		var location = "Point%d" % current_point
		var instance = character_scene.instantiate()
		
		if has_node(location):
			#get_node(location).add_child(instance)
			
			instance.position = get_node(location).global_position
			instance.initialPos = instance.position
			add_child(instance)
			#instance.load_stats(chest_manager.characters[current_point-1])
			instance.get_child(0).assign_data(chest_manager.characters[current_point-1])
			instance.name = "Character_%s" % chest_manager.characters[current_point-1]["name"]
		else:
			print("path invalido")
			
		current_point += 1
