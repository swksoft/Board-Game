class_name placeable extends StaticBody2D

@export var drag_manager : Node2D

func _ready():
	pass#modulate = Color(Color.MEDIUM_AQUAMARINE, 0.7)

func _process(delta):
	if drag_manager.is_dragging:
		visible = true
	else:
		visible = true
