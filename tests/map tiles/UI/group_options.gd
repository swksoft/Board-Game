extends Control

var on_menu = false

@onready var button_container = %V
@onready var button_message = %ButtonMessage
@onready var character_manager = $"../../CharacterManager"

func _ready():
	EventsTest.grouped_character.connect(on_grouped_character)

func _process(_delta):
	if on_menu:
		if Input.is_action_just_pressed("right_click"):
			print("kill")
			on_menu = false
			visible = false
			get_tree().paused = false

func _cancel():
	visible = false
	get_tree().paused = false

func on_grouped_character(grouped_char):
	print("A")
	
	on_menu = true
	
	var positions = character_manager.positions

#func on_show_options(characters_in_group: Array):
	get_tree().paused = true
	
	# Limpiar botones anteriores si existen
	for child in button_container.get_children():
		if child.name != "ButtonMessage":
			button_container.remove_child(child)
			child.queue_free()
	
	# Todos
	var all_button = Button.new()
	all_button.text = "Todos"
	all_button.pressed.connect(self._move_everyone)
	button_container.add_child(all_button)
	
	# Generar
	for position in positions:
		var chars_at_pos : Array = positions[position].chars
		if !chars_at_pos.has(grouped_char): continue
		for char in chars_at_pos:
			var button = Button.new()
			button.text = str(char.name)
			#button.pressed.connect(self._on_button_pressed, char) # no funciona
			button.connect("pressed", _on_button_pressed.bind(char)) # funciona
			#button.pressed.connect(self._on_button_pressed.bind(char)) # funciona
			button_container.add_child(button)
			
			#button.connect("pressed", self, "_on_button_pressed", [character])
	
	# Cancelar
	var cancel_button = Button.new()
	cancel_button.text = "Cancelar"
	cancel_button.pressed.connect(self._cancel)
	button_container.add_child(cancel_button)
	
	visible = true
	
	#for child in button_container.get_children():
		#if child.name != "ButtonMessage":
			#button_container.remove_child(child)
			#child.queue_free()
	#button_container.visible = true

func _move_everyone():
	visible = false
	get_tree().paused = false

func _on_button_pressed(character):
	visible = false
	get_tree().paused = false
	#print("Botón presionado para el personaje: ", character)
	
	for child in character_manager.get_children().size():
		var char_name = character_manager.get_child(child) as CharacterBoard
		#print(char_name)
		if str(char_name) == str(character):
			char_name.can_move = true
			char_name.show_adjacent_tiles(char_name.get_available_tiles())
