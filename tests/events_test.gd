@icon("res://icons/box_icon1.svg")
extends Node

# SIGNALS CHEST SECTION
signal open_chest(char_stats)
signal cancel_open_chest
signal chest_entered

func emit_open_chest(char_stats):
	emit_signal("open_chest", char_stats)
	
func emit_cancel_open_chest():
	cancel_open_chest.emit()
	
func emit_chest_entered():
	chest_entered.emit()

# TODO: CAMBIAR A GLOBAL_DATA_TEST
#func load_csv(file_path: String) -> Array:
	#var file = FileAccess.open(file_path, FileAccess.READ)
	#var data = []
#
	#if file.file_exists(file_path):
		#file.open(file_path, FileAccess.READ)
		#
		#var headers = file.get_csv_line()
		#
		#while not file.eof_reached():
			#var line = file.get_csv_line()
			#
			#if line.size() == headers.size():
				#var dict = {}
				#
				#for i in range(len(headers)):
					#dict[headers[i]] = line[i]
				#
				#data.append(dict)
			#else:
				#pass
		#file.close()
		#
	#return data
