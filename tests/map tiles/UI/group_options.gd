extends Control

signal move_group(char)
signal move_entire_group(chars)

@onready var button_container = %V
@onready var button_message = %ButtonMessage
@onready var character_manager = $"../../../CharacterManager"

func _ready():
	EventsTest.grouped_character.connect(on_grouped_character)

func _process(_delta):
	if character_manager.selecting_character && Input.is_action_just_pressed("right_click"): close_menu()

func close_menu():
	character_manager.selecting_character = false
	visible = false
	get_tree().paused = false

func _cancel():
	close_menu()

func on_grouped_character(grouped_char):
	var char_in_group = []
	
	character_manager.selecting_character = true
	get_tree().paused = true
	visible = true
	
	var positions = character_manager.positions
	
	# Limpiar botones anteriores si existen
	for child in button_container.get_children():
		if child.name != "ButtonMessage" or child.name != "Label":
			button_container.remove_child(child)
			child.queue_free()
	
	# Todos
	var all_button = Button.new()
	
	all_button.text = "Todos"
	all_button.pressed.connect(self._move_everyone.bind(char_in_group))
	button_container.add_child(all_button)
	
	# Generar
	for position in positions:
		var chars_at_pos : Array = positions[position].chars
		
		if !chars_at_pos.has(grouped_char): continue
		
		for char in chars_at_pos:
			var button = Button.new()
			char_in_group.append(char)
			
			button.text = str(char.name)
			button.connect("pressed", _on_button_pressed.bind(char)) # funciona
			
			#button.pressed.connect(self._on_button_pressed, char) # no funciona
			#button.pressed.connect(self._on_button_pressed.bind(char)) # funciona
			#button.connect("pressed", self, "_on_button_pressed", [character])
			
			if char.moved_character == true:
				button.disabled = true
			
			button_container.add_child(button)
			
	# Cancelar
	var cancel_button = Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.pressed.connect(self._cancel)
	button_container.add_child(cancel_button)

	var tip = Label.new()
	tip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tip.add_theme_font_size_override("font_size", 12)
	tip.text = "Cancelar = Click Derecho"
	button_container.add_child(tip)

func _move_everyone(characters):
	close_menu()
	emit_signal("move_entire_group", characters)

func _on_button_pressed(character):
	close_menu()
	emit_signal("move_group", character)
	#print("Botón presionado para el personaje: ", character)
