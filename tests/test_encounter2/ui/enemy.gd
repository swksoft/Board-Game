extends Control

var enemy

@export var rect : TextureRect
var combat_manager : CombatManager

func _ready():
	combat_manager = get_tree().get_first_node_in_group("combat_manager")
	combat_manager.turn_advanced.connect(update)

func init(coming_char):
	#coming_char.stat_changed.connect(update)
	enemy = coming_char
	rect.texture = load(enemy["icon"])
	update()
	
func update():
	print("Enemy hp: " + str(enemy["max_hp"]))
	if enemy["max_hp"] <= 0:
		print(str(enemy.name), " ha sido obliterado.")
		modulate = Color("ffffff00")
