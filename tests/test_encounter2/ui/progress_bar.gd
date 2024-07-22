extends ProgressBar

@export var combat_manager : CombatManager
@export var label : Label

func _ready():
	combat_manager.update_lifebar.connect(on_update_lifebar)
	
func on_update_lifebar():
	max_value = combat_manager.player_total_hp
	value = combat_manager.player_hp
	
	label.text = "HP: " + str(combat_manager.player_hp) + "/" +str(combat_manager.player_total_hp)
