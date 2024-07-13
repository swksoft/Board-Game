extends HBoxContainer

@export var combat_manager : CombatManager
@export var char_ui_scene : PackedScene
@export var center : Control

func _ready():
	combat_manager.chars_ready.connect(on_chars_ready)
	
func on_chars_ready():
	for char in combat_manager.characters:
		var instance = char_ui_scene.instantiate()
		instance.init(char)
		add_child(instance)
	move_child(center, 2)
