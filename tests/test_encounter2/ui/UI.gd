extends Control

@export var combat_manager : CombatManager

@export var sprite_turn : Resource 

func update_turns(value):
	var child_number = $VBoxContainer/Upper/HBoxContainer.get_children()
	print(child_number)
	if child_number.size() > 0:
		for child in child_number.size():
			child_number[child].queue_free()
		
	for turn in combat_manager.total_turns:
		var texture_container = TextureRect.new()
		texture_container.texture = sprite_turn
		$VBoxContainer/Upper/HBoxContainer.add_child(texture_container, true, Node.INTERNAL_MODE_FRONT)

func _ready():
	var characters = combat_manager.characters
	#_on_combat_manager_update_information(characters)
	
func _on_combat_manager_update_information(text):
	$VBoxContainer/Center/PanelContainer/RichTextLabel.append_text(text)

func _on_update_turns(value):
	update_turns(value)

func _on_combat_manager_characters_ready():
	var characters = combat_manager.characters
	
	if characters.size() > 0:
		var index = 1  
		
		for char_name in characters.keys():
			var character_data = characters[char_name]
			
			var path_name = "VBoxContainer/Bottom/Char%d/VBoxContainer/Label" % index
			var path_hp  = "VBoxContainer/Bottom/Char%d/VBoxContainer/GridContainer/Label2" % index
			var path_atk = "VBoxContainer/Bottom/Char%d/VBoxContainer/GridContainer/Label4" % index
			var path_dfs = "VBoxContainer/Bottom/Char%d/VBoxContainer/GridContainer/Label6" % index
			var path_eva = "VBoxContainer/Bottom/Char%d/VBoxContainer/GridContainer/Label8" % index
			
			if has_node(path_name) and has_node(path_hp) and has_node(path_atk) and has_node(path_dfs) and has_node(path_eva):
				get_node(path_name).text = char_name
				get_node(path_hp).text = str(character_data["hp"])
				get_node(path_atk).text = str(character_data["atk"])
				get_node(path_dfs).text = str(character_data["dfs"])
				get_node(path_eva).text = str(character_data["eva"])
				
			index += 1
	else:
		print("No characters available.")

func _on_update_lifebar(value):
	$VBoxContainer/Bottom/Center/ProgressBar.max_value = value
	$VBoxContainer/Bottom/Center/ProgressBar.value = value
	$VBoxContainer/Bottom/Center/ProgressBar/Label.text = str(value) + "/" + str(value)
