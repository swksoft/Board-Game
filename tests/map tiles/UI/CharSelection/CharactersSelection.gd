extends Control
class_name GridSelector

@export var slotContainer_path : GridContainer
@export var charContainer_path : GridContainer

var inventoryDict = {}

var items = []

@onready var slotContainer = slotContainer_path
@onready var charContainer = charContainer_path

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
	
	targetSlotNode.texture = dragSlotNode.texture
	
	if targetTexture == null:
		dragSlotNode.texture = null
	else:
		dragSlotNode.texture = targetTexture
		
	EventsTest.emit_signal_time_down()

func get_slot_node_at_position(pos):
	var allSlotNodes = (slotContainer.get_children() + charContainer.get_children())
	
	for node in allSlotNodes:
		var nodeRect = node.get_global_rect()
		
		if nodeRect.has_point(pos):
			return node
