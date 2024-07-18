extends Node
class_name CombatManager

signal turn_advanced()
signal player_turn
signal update_information(text: String)
signal chars_ready
signal update_turns(value: int)
signal update_lifebar

@export var dice_manager : DiceManager
@export var max_turns := 6

var turns
var characters : Array = []
var enemies : Array = []

var player_total_hp : int = 0
var player_hp : int

func _ready():
	turns = max_turns
	
	
	
	on_turn_advance()
	emit_signal("update_turns", turns)
	
	create_character("Hero", 100, 25, 10, 30, "friend", ["guard", "attack", "heal", "attack", "attack", "standby"])
	create_character("Mage", 80, 25, 5, 25, "friend", ["standby", "standby", "attack", "heal", "standby", "standby"])
	create_character("Warrior", 120, 15, 20, 1, "friend", ["attack", "attack", "standby", "attack", "attack", "guard"])
	create_character("Ninja", 120, 15, 20, 1, "friend", ["standby", "attack", "attack", "standby", "attack", "assassinate"])
	
	create_character("Demon", 100, 10, 20, 1, "enemy", ["attack", "standby", "attack", "attack", "standby", "attack"])
	create_character("George", 100, 10, 20, 1, "enemy", ["attack", "attack", "standby", "attack", "attack", "attack"])
	
	chars_ready.emit()
	#emit_signal("characters_ready")
	
	get_total_health()
	get_enemy_data()
	
	turn_advanced.connect(on_turn_advance)

func get_enemy_data():
	var enemies_list = []
	for enemy_data in enemies:
		enemies_list.push_back(enemy_data["name"])
	var message = "Your enemies are: " + ", ".join(enemies_list) + "."
	update_information.emit(message)

func on_turn_advance():
	var message = "\n ===== TURN " + str(turns) + " =====\n"
	update_information.emit(message, false)
	
	if turns > 1:
		turns -= 1
		
		print(turns)
		
		emit_signal("update_turns", turns)
		
		return
		
	update_information.emit("Batalla completada.")
	
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

func get_total_health():
	for character_data in characters:
		player_total_hp += character_data["max_hp"]
		
	player_hp = player_total_hp
	
	emit_signal("update_lifebar")

func _on_attack_button_button_down():
	emit_signal("update_turns", turns)
	player_turn.emit()
	party_attack(characters, enemies)
	party_attack(enemies, characters)
	#enemy_attack(enemies, characters)
	turn_advanced.emit()

func party_attack(party, opp):
	var enemy_icon : String
	var icon : String
	
	for character in party:
		var dice = dice_manager.throw_dice(character.dice, character)
		var action =  character.actions[dice-1]
		
		if character.type == "enemy":
			enemy_icon = "[img=16x16 region=832,1600,32,32]res://maps/assets/ProjectUtumno_full.png[/img] "
		
		match action:
			"attack":
				if character.type == "enemy":
					player_hp -= character.atk
					emit_signal("update_lifebar")
				else: opp.pick_random().hp -= character.atk
				
				icon = "[img=16x16 region=960,1472,32,32]res://maps/assets/ProjectUtumno_full.png[/img]"
			"assassinate": 
				var picked = opp.pick_random()
				var chance = 100 - floor(picked.hp / picked.max_hp) * 100
				var rng = RandomNumberGenerator.new()
				var my_random_number = rng.randf_range(0, 100)
				if my_random_number <= chance: picked.hp = 0
				icon = "[img=16x16 region=480,1632,32,32]res://maps/assets/ProjectUtumno_full.png[/img]"
			"heal":
				icon = "[img=16x16 region=1952,1312,32,32]res://maps/assets/ProjectUtumno_full.png[/img]"
			"standby":
				icon = "[img=16x16 region=1152,960,32,32]res://maps/assets/ProjectUtumno_full.png[/img]"
			"guard":
				icon = "[img=16x16 region=1088,1184,32,32]res://maps/assets/ProjectUtumno_full.png[/img]"
			"_":
				icon = "[img=16x16 region=480,1632,32,32]res://maps/assets/ProjectUtumno_full.png[/img]"
		
		var message = enemy_icon + character.name + " rolled: " + action + " " + icon
		
		update_information.emit(message)
		
