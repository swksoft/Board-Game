extends Button

func _on_button_down():
	disabled = true

func _on_combat_manager_turn_advanced():
	disabled = false
