extends HBoxContainer

@export var dice_manager : DiceManager
@export var combat_manager : CombatManager
@export var dice_scene : PackedScene

func _ready():
	dice_manager.dice_thrown.connect(on_dice_thrown)
	combat_manager.turn_advanced.connect(clear)
	
func on_dice_thrown(result, _user):
	var dice_scene = dice_scene.instantiate()
	dice_scene.init(result)
	add_child(dice_scene)

func clear():
	for n in get_children():
		n.queue_free()
