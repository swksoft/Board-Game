extends GridSelector

func _process(delta):
	var mouse_position = get_global_mouse_position()
	
	if mouse_position.y > 344 and mouse_position.x > 152:
		mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
