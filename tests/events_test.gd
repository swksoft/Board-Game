@icon("res://icons/box_icon1.svg")
extends Node

# SIGNALS CHEST SECTION
signal open_chest(char_stats)
signal cancel_open_chest
signal chest_entered
signal character_moved(char, move_in_group, from)
signal grouped_character(char)

func emit_open_chest(char_stats):
	emit_signal("open_chest", char_stats)
	
func emit_cancel_open_chest():
	cancel_open_chest.emit()
	
func emit_chest_entered():
	chest_entered.emit()

func emit_character_moved(char, move_in_group, from):
	character_moved.emit(char, move_in_group, from)

func emit_grouped_character(char):
	grouped_character.emit(char)

