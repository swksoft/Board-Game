extends Control

@export var combat_manager : CombatManager

func _ready():
	var characters = combat_manager.characters
	#_on_combat_manager_update_information(characters)
	
func _on_combat_manager_update_information(text):
	$VBoxContainer/Center/PanelContainer/RichTextLabel.append_text(text)

