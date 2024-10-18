@icon("res://icons/icon_happy.svg")
class_name CharaBoard extends Node2D

@export var character_resource : CharacterResource

var character_manager = CharacterManagerBoard
var spawn_point : Vector2i
var current_position : Vector2i
var tile_map : BoardTile

func initialize(resource : Resource):
	character_resource = resource
	
	%Sprite.texture = character_resource.icon
	name = str(character_resource.char_name)

func _ready():
	if !character_resource:
		printerr("RESOURCE NO ENCONTRADO")
		return
		
func enter_group(n):
	var i = n + 1
	var y = -16
	var x = -40
	if i > 2:
		x = -40
		y = 16
		i -= 2
	x += 20 * i
		
	character_manager.in_group = true
	%Sprite.scale = Vector2(0.5, 0.5)
	%Sprite.offset = Vector2(x, y)
	
func leave_group():
	character_manager.in_group = false
	%Sprite.offset = Vector2(0, 0)
	%Sprite.scale = Vector2(1, 1)
