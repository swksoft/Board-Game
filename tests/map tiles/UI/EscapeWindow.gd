extends PanelContainer

@export var menu_scene : PackedScene

func _ready():
	%EscapeWindow.visible = false
	
func _on_escape_pressed():
	%EscapeWindow.visible = true
	get_tree().paused = true

func _on_button_yes_pressed():
	get_tree().change_scene_to_packed(menu_scene)

func _on_button_no_pressed():
	%EscapeWindow.visible = false
	get_tree().paused = false
