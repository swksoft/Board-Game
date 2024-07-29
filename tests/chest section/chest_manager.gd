class_name ChestManager extends Node

signal open_chest
signal load_data

var characters : Array = []
var items : Array = []

func _ready():
	characters = load_stats("res://resources/data/characters.csv")
	items = load_stats("res://resources/data/items.csv")
	
	load_data.emit()
	
func load_stats(file_path: String) -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var data = []

	if file.file_exists(file_path):
		file.open(file_path, FileAccess.READ)
		
		var headers = file.get_csv_line()
		
		while not file.eof_reached():
			var line = file.get_csv_line()
			
			if line.size() == headers.size():
				var dict = {}
				
				for i in range(len(headers)):
					dict[headers[i]] = line[i]
				
				data.append(dict)
			else:
				pass
		file.close()
		
	return data
