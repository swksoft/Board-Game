extends Control

@onready var button_message = $CenterContainer/ButtonContainer/V/ButtonMessage
@onready var button_container = $CenterContainer/ButtonContainer/V

func _use_skill():
	# Lógica para abrir el cofre con la habilidad "Ganzúa"
	print("Usando habilidad Ganzúa para abrir el cofre.")
	button_container.visible = false
	get_tree().paused = false

func _try_open_chest():
	# Lógica para intentar abrir el cofre
	print("Intentando abrir el cofre.")
	button_container.visible = false
	get_tree().paused = false

func _cancel():
	# Lógica para cancelar la acción
	print("Acción cancelada.")
	button_container.visible = false
	EventsTest.emit_cancel_open_chest()
	get_tree().paused = false

func _on_chest_show_options(char_stats):
	get_tree().paused = true
	
	# Limpiar botones anteriores si existen
	for child in button_container.get_children():
		if child.name != "ButtonMessage":
			#print("lol!")
			button_container.remove_child(child)
			child.queue_free()
	button_container.visible = true
	
	# Verificar si el personaje tiene la habilidad "Ganzúa"
	if "ganzua" in char_stats.actions:
		var skill_button = Button.new()
		skill_button.text = "Ganzúa"
		skill_button.pressed.connect(self._use_skill)
		button_container.add_child(skill_button)
	
	# Botón para intentar abrir el cofre
	var open_button = Button.new()
	open_button.text = "Intentar abrir"
	open_button.pressed.connect(self._try_open_chest)
	button_container.add_child(open_button)
	
	# Botón para cancelar
	var cancel_button = Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.pressed.connect(self._cancel)
	button_container.add_child(cancel_button)
