extends VBoxContainer

func _ready():
	%Up.pressed.connect(self._move_camera.bind(Vector2.UP))
	%Down.pressed.connect(self._move_camera.bind(Vector2.DOWN))
	%Left.pressed.connect(self._move_camera.bind(Vector2.LEFT))
	%Right.pressed.connect(self._move_camera.bind(Vector2.RIGHT))

func _move_camera(direction):
	EventsTest.emit_move_camera(direction)
