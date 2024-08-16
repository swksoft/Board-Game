extends Camera2D

func _ready():
	EventsTest.move_camera.connect(on_move_camera)

func move(direction: Vector2):
	match direction:
		Vector2.UP:
			if position.y >= -208:
				global_position += direction * 15
		Vector2.DOWN:
			if position.y <= 119:
				global_position += direction * 15
		Vector2.LEFT:
			if position.x >= -304:
				global_position += direction * 15
		Vector2.RIGHT:
			if position.x <= 65:
				global_position += direction * 15

func _process(delta):
	#print(position)
	if Input.is_action_just_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)

func on_move_camera(direction):
	move(direction)
