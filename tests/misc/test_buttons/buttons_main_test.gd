extends Control

var skill = "ganzua"

@onready var button_container = $HBoxContainer

func _ready():
	var button = Button.new()
	button.text = "Test"
	button.pressed.connect(self._button_pressed)
	button_container.add_child(button)
	
	# Botón abrir cofre skill (tch)
	if skill == "ganzua":
		var skill_button = Button.new()
		skill_button.text = "Ganzúa"
		skill_button.pressed.connect(self._use_skill)
		button_container.add_child(skill_button)
		
	# Botón intentar abrir el cofre (board_lck)
	var open_button = Button.new()
	open_button.text = "Intentar abrir"
	open_button.pressed.connect(self._try_open_chest)
	button_container.add_child(open_button)
	
	# Botón para cancelar
	var cancel_button = Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.pressed.connect(self._cancel)
	button_container.add_child(cancel_button)

func _button_pressed():
	print("Hello world!")

func _use_skill():
	# Lógica para abrir el cofre con la habilidad "Ganzúa"
	print("Usando habilidad Ganzúa para abrir el cofre.")
	# Aquí va la lógica para abrir el cofre con éxito

func _try_open_chest():
	# Lógica para intentar abrir el cofre
	print("Intentando abrir el cofre.")
	# Aquí va la lógica para calcular la probabilidad de éxito basada en las estadísticas

func _cancel():
	# Lógica para cancelar la acción
	print("Acción cancelada.")
	# Aquí va la lógica para cerrar el menú o realizar otra acción de cancelación
