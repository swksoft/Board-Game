extends Control
class_name GridSelector

signal can_start

@export var slotContainer_path : GridContainer
@export var charContainer_path : GridContainer

var CharactersDict = {}
var Characters = GlobalDataTest.load_characters_as_resources("res://resources/data/characters.csv")
var can_use_flag = false
var characters_used

@onready var slotContainer = slotContainer_path
@onready var charContainer = charContainer_path

func _ready():
	var available_characters = GlobalDataTest.load_characters_as_resources("res://resources/data/characters.csv")
	var number = 0
	var default_number = 0
	
	CharactersDict = {
		"Slots": slotContainer,
		"AvailableCharacters": charContainer
	}
	
	for child in available_characters:
		if child.char_name == "Richard" or child.char_name == "John" or child.char_name == "Duende Verde" or child.char_name == "Cepillo":
			slotContainer.get_child(default_number).set_data(child)
			print_debug(slotContainer.get_child(number))
			default_number += 1
			continue
		charContainer.get_child(number).set_data(child)
		number += 1
	
	_refresh_ui()

func add_char(char: CharacterResource):
	char.inventarSlot

func _get_drag_data(at_position):
	var dragSlotNode = get_slot_node_at_position(at_position)
	
	if dragSlotNode == null: return
	
	if dragSlotNode.texture == null: return
	
	var dragPreviewNode = dragSlotNode.duplicate()
	dragPreviewNode.custom_minimum_size = Vector2(64, 64)
	set_drag_preview(dragPreviewNode)
	
	return dragSlotNode

func _can_drop_data(at_position, data):
	var targetSlotNode = get_slot_node_at_position(at_position)
	
	return targetSlotNode != null
	
func _drop_data(at_position, dragSlotNode):
	var targetSlotNode = get_slot_node_at_position(at_position)
	var targetTexture = targetSlotNode.texture
	var targetResource = targetSlotNode.char_resource
	
	targetSlotNode.set_data(dragSlotNode.char_resource)
	dragSlotNode.set_data(targetResource)
	
	#targetSlotNode.texture = dragSlotNode.texture
	#
	#if targetTexture == null:
		#dragSlotNode.texture = null
	#else:
		#dragSlotNode.texture = targetTexture
		
	_refresh_ui()
		
	EventsTest.emit_signal_time_down()

func get_slot_node_at_position(pos):
	var allSlotNodes = (slotContainer.get_children() + charContainer.get_children())
	
	for node in allSlotNodes:
		var nodeRect = node.get_global_rect()
		
		if nodeRect.has_point(pos):
			return node

func _refresh_ui():
	characters_used = []

	var used_slots = slotContainer.get_children()
	
	for slot in used_slots:
		if slot.char_resource == null:
			characters_used.append(null)
		else:
			characters_used.append(slot.char_resource)
	
	for slot in characters_used:
		if slot == null:
			print(characters_used)
			break
		else:
			print(characters_used)

	if characters_used[0] != null and characters_used[1] != null and characters_used[2] != null and characters_used[3] != null:
		emit_signal("can_start")
	else:
		if %Finish != null:
			%Finish.disabled = true

func _on_can_start():
	%Finish.disabled = false

func _on_finish_pressed():
	var map_01_scene = load("res://tests/map tiles/test_map.tscn").instantiate()
	
	var characters_scene = map_01_scene.get_node("CharacterManager")
	
	characters_scene.init(characters_used)
	
	get_tree().root.add_child(map_01_scene)
	get_tree().current_scene.queue_free()  
