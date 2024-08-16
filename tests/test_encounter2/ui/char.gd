extends PanelContainer

@export var name_label : Label
@export var hp_label : Label
@export var atk_label : Label
@export var dfs_label : Label
@export var eva_label : Label
@export var rect : TextureRect

var combat_manager : CombatManager

var char

func _ready():
	combat_manager = get_tree().get_first_node_in_group("combat_manager")
	combat_manager.turn_advanced.connect(update)

func init(coming_char: Dictionary):
	#coming_char.stat_changed.connect(update)
	char = coming_char
	rect.texture = load(char["icon"])
	update()
	
func update():
	name_label.text = char["name"]
	hp_label.text = str(char["max_hp"])
	atk_label.text = str(char["atk"])
	dfs_label.text = str(char["def"])
	eva_label.text = str(char["eva"])
