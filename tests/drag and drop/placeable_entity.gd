class_name draggable extends Node2D

@export var drag_manager : DragManager
@export var marker : Marker2D

var initialPos : Vector2
var dragable = false
var is_inside_dropable = false
var body_ref
var offset : Vector2
var returning = false

func interact():
	print("hola")

func _ready():
	initialPos = marker.global_position

func _process(delta):
	#print(marker.position)
	#print(marker.global_position)
	print(global_position)
	# TODO: QUE NO SEA CLICKEABLE AL SOLTAR CLICK A MENOS QUE REGRESE A SU POSICION ORIGINAL (clickear el icono muchas veces lo bugea)
	if returning: return
	if dragable:
		if Input.is_action_just_pressed("click"):
			print("a")
			offset = get_global_mouse_position() - global_position
			drag_manager.is_dragging = true
		
		if Input.is_action_pressed("click"):
			print("a")
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			print("a")
			drag_manager.is_dragging = false
			
			if is_inside_dropable:
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", body_ref.position, 0.2). set_ease(Tween.EASE_OUT)
				unscale()
				interact()
				# TODO: DISPLAY DE SKILLS
				
			else:
				return_to_original_pos()
			
func return_to_original_pos():
	returning = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", initialPos, 0.2). set_ease(Tween.EASE_OUT)
	tween.finished.connect(on_return)

func unscale():
	dragable = false
	scale = Vector2(1, 1)

func _on_area_2d_mouse_entered():
	if not drag_manager.is_dragging:
		dragable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	if not drag_manager.is_dragging:
		unscale()

func _on_area_2d_body_entered(body):
	print("a")
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		#body.modulate = Color(Color.REBECCA_PURPLE, 1)
		body_ref = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		#body.modulate = Color(Color.MEDIUM_PURPLE, 1)
		
func on_return():
	returning = false
