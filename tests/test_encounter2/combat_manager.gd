extends Node
class_name CombatManager

signal turn_advanced()
signal update_information(text: String)
signal characters_ready
signal update_lifebar(value : int)
signal update_turns(value: int)

@export var characters : Dictionary = {}
@export var max_turns : int = 5

var total_turns : int

func _ready():
	total_turns = max_turns
	
	#update_information.emit("Test.\n")
	create_character("Hero", 100, 20, 10, 30)
	create_character("Mage", 80, 25, 5, 25)
	create_character("Warrior", 120, 15, 20, 1)
	
	emit_signal("characters_ready")
	emit_signal("update_lifebar", get_total_health())
	emit_signal("update_turns", total_turns)
	
func create_character(character_name : String, hp : int, atk : int, dfs : int, eva : int):
	var character_data = {
		"hp": hp,
		"atk": atk,
		"dfs": dfs,
		"eva": eva
	}
	characters[character_name] = character_data
	return character_data

func get_total_health():
	var total_health = 0
	for character_data in characters.values():
		total_health += character_data["hp"]
	return total_health


func _on_attack_button_pressed():
	total_turns -= 1
	emit_signal("update_turns", total_turns)
	
