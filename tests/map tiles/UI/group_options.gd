extends Control

@onready var button_container = %ButtonContainer
@onready var button_message = %ButtonMessage

func _cancel():
	button_container.visible = false
	get_tree().paused = false

func on_show_options(characters_in_group: Array):
	get_tree().paused = true
	
	button_container.clear()
	
	for character in characters_in_group:
		var button = Button.new()
		button.text = character.name
		button_container.add_child(button)
	#
	#for child in button_container.get_children():
		#if child.name != "ButtonMessage":
			#button_container.remove_child(child)
			#child.queue_free()
	#button_container.visible = true
