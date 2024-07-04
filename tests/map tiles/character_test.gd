extends Node2D

var movement = 1
var grid_size = 32

var mouse_inside_area = false

@onready var tile_map = get_parent().get_node("TileMap")

func _ready():
	var area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(grid_size / 2, grid_size / 2)
	collision_shape.shape = shape
	area.add_child(collision_shape)
	area.position = position + Vector2.RIGHT * grid_size
	#area.position = position + offset * grid_size
	area.input_event.connect(_on_move_area)
	add_child(area)

func _process(delta):
	if mouse_inside_area:
		if Input.is_action_just_pressed("click"):
			print_debug("Character Clicked")

func _on_area_2d_mouse_entered():
	mouse_inside_area = true

func _on_area_2d_mouse_exited():
	mouse_inside_area = false

func _on_move_area(viewport, event, shape_idx, area_position):
	print("a")
