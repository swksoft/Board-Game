extends Node
class_name CombatManager

signal turn_advanced()
signal update_information(text: String)
signal chars_ready
signal update_turns(value: int)

var characters : Array = []

@export var dice_manager : DiceManager
@export var max_turns := 6

var turns 

func _ready():
	turns = max_turns
	
	create_character("Hero", 100, 20, 10, 30, "friend")
	create_character("Mage", 80, 25, 5, 25, "friend")
	create_character("Warrior", 120, 15, 20, 1, "friend")
	create_character("Ninja", 120, 15, 20, 1, "friend")
	
	chars_ready.emit()
	
	#emit_signal("characters_ready")
	#emit_signal("update_lifebar", get_total_health())
	emit_signal("update_turns", turns)
	
	turn_advanced.connect(on_turn_advance)

func on_turn_advance():
	if turns > 1:
		turns -= 1
		
		print(turns)
		
		return
		
	print("===== GAME OVER =====")
	
	$"../GameOverScreen".visible = true
	get_tree().paused = true

func create_character(character_name: String, hp: int, atk: int, dfs: int, eva: int, type: String):
	var character_data = {
		"name": character_name,
		"hp": hp,
		"atk": atk,
		"dfs": dfs,
		"eva": eva,
		"dice": 6,
		"type": type
	}
	
	characters.push_back(character_data)
	
	return character_data

#func get_total_health():
	#var total_health = 0
	#for character_data in characters.values():
		#total_health += character_data["hp"]
	#return total_health

func _on_attack_button_button_down():
	emit_signal("update_turns", turns)
	
	turn_advanced.emit()
	for character in characters:
		dice_manager.throw_dice(character.dice, character)
	
	
