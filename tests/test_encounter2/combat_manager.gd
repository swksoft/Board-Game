extends Node
class_name CombatManager

signal turn_advanced()
signal player_turn
signal update_information(text: String)
signal chars_ready
signal update_turns(value: int)

var characters : Array = []
var enemies : Array = []

@export var dice_manager : DiceManager
@export var max_turns := 6

var turns 

func _ready():
	turns = max_turns
	
	create_character("Hero", 100, 20, 10, 30, "friend", ["guard", "attack", "heal", "attack", "attack", "standby"])
	create_character("Mage", 80, 25, 5, 25, "friend", ["standby", "standby", "attack", "heal", "standby", "standby"])
	create_character("Warrior", 120, 15, 20, 1, "friend", ["attack", "attack", "standby", "attack", "attack", "guard"])
	create_character("Ninja", 120, 15, 20, 1, "friend", ["standby", "attack", "attack", "standby", "attack", "assassinate"])
	create_character("Demon", 100, 10, 20, 1, "enemy", ["attack", "attack", "attack", "attack", "attack", "attack"])
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

func create_character(character_name: String, hp: int, atk: int, dfs: int, eva: int, type: String, actions : Array, image: Vector2 = Vector2(0, 2560) ):
	var character_data = {
		"name": character_name,
		"max_hp": hp,
		"hp": hp,
		"atk": atk,
		"dfs": dfs,
		"eva": eva,
		"dice": 6,
		"type": type,
		"actions": actions,
		"image": image
	}
	
	if type == "friend": characters.push_back(character_data)
	else: enemies.push_back(character_data)
	
	return character_data

#func get_total_health():
	#var total_health = 0
	#for character_data in characters.values():
		#total_health += character_data["hp"]
	#return total_health

func _on_attack_button_button_down():
	emit_signal("update_turns", turns)
	player_turn.emit()
	party_attack(characters, enemies)
	party_attack(enemies, characters)
	turn_advanced.emit()
	
func party_attack(party, opp):
	for character in party:
		var dice = dice_manager.throw_dice(character.dice, character)
		var action =  character.actions[dice-1]
		match action:
			"attack": opp.pick_random().hp -= character.atk
			"assassinate": 
				var picked = opp.pick_random()
				var chance = 100 - floor(picked.hp / picked.max_hp) * 100
				var rng = RandomNumberGenerator.new()
				var my_random_number = rng.randf_range(0, 100)
				if my_random_number <= chance: picked.hp = 0
		print(character.name + " used: " + action)
