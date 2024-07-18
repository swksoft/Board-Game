extends Control

@export var combat_manager : CombatManager

var message_queue: Array = []

func _ready():
	var characters = combat_manager.characters
	
	_on_combat_manager_update_information("[color=red]You are in combat mode.[/color]")
	
	_print_next_message()
	
func _on_update_lifebar(value):
	$VBoxContainer/Bottom/Center/ProgressBar.max_value = value
	$VBoxContainer/Bottom/Center/ProgressBar.value = value
	$VBoxContainer/Bottom/Center/ProgressBar/Label.text = str(value) + "/" + str(value)

func _on_combat_manager_update_information(text: String, arrow = true):
	if arrow: message_queue.append("> " + text + "\n") #$VBoxContainer/Center/PanelContainer/BattleLog.append_text("> " + text + "\n")
	else: message_queue.append(text + "\n")#$VBoxContainer/Center/PanelContainer/BattleLog.append_text(text + "\n")
	print(message_queue)

func _print_next_message():
	if message_queue.size() > 0:
		var next_message = message_queue.pop_front()
		$VBoxContainer/Center/PanelContainer/BattleLog.append_text(next_message)
		#rich_text_label.append_bbcode(next_message + "\n")
		$VBoxContainer/Center/PanelContainer/BattleLog/Timer.start()
	else:
		pass

func _on_timer_timeout():
	_print_next_message()
