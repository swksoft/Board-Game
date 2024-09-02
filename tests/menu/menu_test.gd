extends Control

@onready var characters_selection = $ScreenSelection/CharactersSelection

func _on_exit_pressed():
	get_tree().quit()

func _on_start_pressed():
	%ScreenSelection.visible = true

func _on_return_pressed():
	%ScreenSelection.visible = false

func can_start():
	if characters_selection.can_use_flag:
		%Finish.disabled = false
