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
@export var enemy_container : NodePath
@export var time = 1

var turns
var characters : Array = []
var enemies : Array = []

var player_total_hp : int = 0
var player_hp : int

func _ready():
	randomize()
	max_turns = randi_range(3,6)
	
	turns = max_turns
	
	var available_characters = GlobalDataTest.available_characters
	var available_enemies = GlobalDataTest.available_enemies
	
	for char_data in available_characters: characters.push_back(char_data)
	for enemy_data in available_enemies: enemies.push_back(enemy_data)
	emit_signal("update_turns", turns)
	
	chars_ready.emit()
	
	get_total_health()
	#get_enemy_data()
	
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
		
		emit_signal("update_turns", turns)
		
		return
		
	update_information.emit("Batalla completada.")
	
	$"../GameOverScreen".visible = true
	get_tree().paused = true

func get_total_health():
	var total_hp = 0
	for character_data in characters:
		total_hp += character_data["max_hp"]
		
	player_total_hp = total_hp
	player_hp = player_total_hp
	emit_signal("update_lifebar")

func _on_attack_button_button_down():
	emit_signal("update_turns", turns)
	player_turn.emit()
	await party_attack(characters, enemies)
	await party_attack(enemies, characters)
	#enemy_attack(enemies, characters)
	turn_advanced.emit()

func take_damage(amount):
	player_hp -= amount
	
	if player_hp <= 0:
		player_hp = 0
		update_information.emit("Game Over")
		$"../GameOverScreen".visible = true
		get_tree().paused = true
		
	emit_signal("update_lifebar")

func party_attack(party, opp):
	var enemy_icon : String
	var icon : String
	
	for character in party:
		await get_tree().create_timer(time).timeout
		var dice = dice_manager.throw_dice(character.dice, character)
		var action =  character.actions[dice-1]
		
		if character.type == "enemy":
			enemy_icon = "[img=16x16 region=832,1600,32,32]res://maps/assets/ProjectUtumno_full.png[/img] "
		
		match action:
			"attack":
				if character.type == "enemy":
					take_damage(character.atk)
				else:
					#print_debug("ENEMY SELECTED: ", enemy_container.find_child(str(opp.pick_random()["name"]))) # opp.pick_random()["name"]).name
					var enemy_selected = get_node(enemy_container).get_node(opp.pick_random()["name"])
					#var enemy_selected = enemy_container.find_child(str(opp.pick_random()["name"]))
					
					##TODO metodo de tomar daño en personajes y enemigos
					enemy_selected.hp -= character.atk
					
				icon = "[img=16x16 region=960,1472,32,32]res://maps/assets/ProjectUtumno_full.png[/img]"
			#"assassinate": 
				#if character.type == "enemy":
					#var chance = 100 - floor(player_hp / player_total_hp) * 100
					#var rng = RandomNumberGenerator.new()
					#var my_random_number = rng.randf_range(0, 100)
					#if my_random_number <= chance: take_damage(player_hp)
				#else:
					#var picked = get_node(enemy_container).get_node(opp.pick_random()["name"])
					#var chance = 100 - floor(picked.hp / picked.max_hp) * 100
					#var rng = RandomNumberGenerator.new()
					#var my_random_number = rng.randf_range(0, 100)
					#if my_random_number <= chance: take_damage(picked.hp, picked.max_hp)
				
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
		emit_signal("update_lifebar")
