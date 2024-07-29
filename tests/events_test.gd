@icon("res://icons/box_icon1.svg")
extends Node

# SIGNALS CHEST SECTION
signal open_chest(char_stats)

func emit_open_chest(char_stats):
	emit_signal("open_chest", char_stats)
