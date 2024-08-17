extends Control

@export var rect : TextureRect

var enemy
var combat_manager : CombatManager
var hp
var max_hp

func _ready():
	combat_manager = get_tree().get_first_node_in_group("combat_manager")
	combat_manager.turn_advanced.connect(update)

func init(coming_char):
	#coming_char.stat_changed.connect(update)
	
	enemy = coming_char
	max_hp = enemy["max_hp"]
	hp = max_hp
	rect.texture = load(enemy["icon"])
	update()
	
func update():
	#print("Enemy hp: " + str(enemy["max_hp"]))
	if hp <= 0:
		print(str(enemy.name), " ha sido obliterado.")
		modulate = Color("ffffff00")
