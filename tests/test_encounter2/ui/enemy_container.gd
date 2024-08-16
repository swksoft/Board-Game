extends HBoxContainer

@export var combat_manager : CombatManager
@export var enemy_scene : PackedScene

func _ready():
	combat_manager.chars_ready.connect(on_chars_ready)
	
func on_chars_ready():
	print_debug(combat_manager.enemies)
	
	for enemy in combat_manager.enemies:
		print(enemy)
		var instance = enemy_scene.instantiate()
		add_child(instance)
		instance.init(enemy)
