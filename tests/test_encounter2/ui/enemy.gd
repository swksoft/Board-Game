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
	rect.texture.region = Rect2(enemy.image.x, enemy.image.y, 32, 32)
	update()
	
func update():
	print("Enemy hp: " + str(enemy.hp))
