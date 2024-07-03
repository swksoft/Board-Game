extends StaticBody2D

@export var drag_manager : Node2D

#@onready var drag = drag_manager

func _ready():
	modulate = Color(Color.MEDIUM_AQUAMARINE, 0.7)

func _process(delta):
	if drag_manager.is_dragging:
		visible = true
	else:
		visible = false
