class_name Character_Treasure extends draggable

signal open_chest(data)

func _ready():
	drag_manager = get_tree().get_root().get_node("MainChest").get_node("DragManager")

func interact():
	var stats = $Stats
	print(name, " entró")
	emit_signal("open_chest", stats.character_data)

func _on_stats_icon_ready():
	var sprite = $Sprite2D as Sprite2D
	var data = $Stats
	sprite.scale *= 4
	sprite.texture = load(data.icon)
	
