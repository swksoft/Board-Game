extends Node
class_name CombatManager

signal turn_advanced()
signal update_information(text: String)
signal chars_ready

var characters : Array = []

@export var dice_manager : DiceManager

func _ready():
	create_character("Hero", 100, 20, 10, 30)
	create_character("Mage", 80, 25, 5, 25)
	create_character("Warrior", 120, 15, 20, 1)
	chars_ready.emit()
	
	emit_signal("characters_ready")
	emit_signal("update_lifebar", get_total_health())
	emit_signal("update_turns", total_turns)
	
func create_character(character_name : String, hp : int, atk : int, dfs : int, eva : int):
	var character_data = {
		"name": character_name,
		"hp": hp,
		"atk": atk,
		"dfs": dfs,
		"eva": eva,
		"dice": 6
	}
	characters.push_back(character_data)
	return character_data

func get_total_health():
	var total_health = 0
	for character_data in characters.values():
		total_health += character_data["hp"]
	return total_health


func _on_attack_button_pressed():
	total_turns -= 1
	emit_signal("update_turns", total_turns)
	

func _on_attack_button_button_down():
	turn_advanced.emit()
	for character in characters:
		dice_manager.throw_dice(character.dice, character)
