@icon("res://icons/icon_happy.svg")
class_name Character_Treasure extends draggable

var character

@onready var stats_character = $Stats

func _ready():
	drag_manager = get_tree().get_root().get_node("MainChest").get_node("DragManager")
	EventsTest.cancel_open_chest.connect(return_to_original_pos)

func _process(delta: float) -> void:
	if is_chest_opening(): return
	super._process(delta)

func init(coming_char):
	#coming_char.stat_changed.connect(update)
	character = coming_char

func interact():
	var stats = $Stats
	print(name, " entró")
	#emit_signal("open_chest", stats.character_data)
	EventsTest.emit_open_chest(stats_character.character_data)

func _on_stats_icon_ready():
	var sprite = $Sprite2D as Sprite2D
	var data = $Stats
	sprite.scale *= 2
	sprite.texture = load(data.icon)

func is_chest_opening():
	var chest = get_tree().get_first_node_in_group("dropable") as Chest
	return chest.opening

func _on_area_2d_mouse_entered():
	if is_chest_opening(): return
	super._on_area_2d_mouse_entered()
