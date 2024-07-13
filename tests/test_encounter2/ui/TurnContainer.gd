extends HBoxContainer

@export var combat_manager : CombatManager
@export var upper_container : Control
@export var sprite_turn : Resource 

func _ready():
	combat_manager.update_turns.connect(on_turn_update)
	
func on_turn_update(value : int):
	#print(upper_container.get_children())

	for child in upper_container.get_children():
		if child is TextureRect:
			child.queue_free()
		
	for turn in value:
		var texture_container = TextureRect.new()
		texture_container.texture = sprite_turn
		upper_container.add_child(texture_container)
