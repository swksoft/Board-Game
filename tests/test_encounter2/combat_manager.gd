extends Node
class_name CombatManager

signal turn_advanced()
signal update_information(text: String)

@export var characters : Dictionary = {}

func _ready():
	update_information.emit("Test.\n")
	create_character("Hero", 100, 20, 10, 30)
	create_character("Mage", 80, 25, 5, 25)
	create_character("Warrior", 120, 15, 20, 1)
	
	#print_available_characters()
	
func create_character(character_name : String, hp : int, atk : int, dfs : int, eva : int):
	var character_data = {
		"hp": hp,
		"atk": atk,
		"dfs": dfs,
		"eva": eva
	}
	characters[character_name] = character_data
	return character_data

func get_character(char_name: String):
	if characters.has(char_name):
		return characters[char_name]
	else:
		return null

func print_available_characters():
	for char_name in characters.keys():
		var character_data = characters[char_name]
		print("Character: ", char_name, " - Data: ", character_data)
