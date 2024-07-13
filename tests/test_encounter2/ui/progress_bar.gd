extends ProgressBar

@export var combat_manager : CombatManager
@export var label : Label

func _ready():
	combat_manager.chars_ready.connect(on_chars_ready)
	
func on_chars_ready():
	var total_hp = 0
	for char in combat_manager.characters:
		total_hp += char.hp
	label.text = str(total_hp)
