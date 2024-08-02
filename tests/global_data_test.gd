@icon("res://icons/box_icon1.svg")
extends Node

var all_characters = {}
var all_enemies = {}
var all_items = {}

var available_characters = []
var available_items_ids = []

# Función para cargar datos desde un archivo .csv
func load_csv(file_path: String) -> Array:
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

# Función para cargar personajes desde el archivo .csv
func load_characters(file_path: String):
	var data = load_csv(file_path)
	#for i in range(1, data.size()):
	for i in range(data.size()):
		var char_data = data[i]
		
		#all_characters[char_data[0]] = {
		all_characters[i] = {
			"name": char_data["name"],
			"class": char_data["class"],
			"atk": char_data["atk"].to_int(),
			"eva": char_data["eva"].to_int(),
			"def": char_data["def"].to_int(),
			"lck_board": char_data["lck_board"].to_int(),
			"tch": char_data["tch"].to_int(),
			"agl": char_data["agl"].to_int(),
			"bls": char_data["bls"].to_int(),
			"lck_interact": char_data["lck_interact"].to_int(),
			"cht": char_data["cht"].to_int(),
			"icon": char_data["icon"],
			"max_hp": char_data["max_hp"].to_int(),
			"type": char_data["type"],
			"dice": char_data["dice"].to_int(),
			"actions": char_data["actions"].split(",") # Convierte las acciones en un array de strings
		}

# Función para cargar enemigos desde el archivo .csv
func load_enemies(file_path: String):
	var data = load_csv(file_path)
	for i in range(data.size()):
		var enemy_data = data[i]
		all_enemies[i] = {
			"name": enemy_data["name"],
			"atk": enemy_data["atk"].to_int(),
			"eva": enemy_data["eva"].to_int(),
			"def": enemy_data["def"].to_int(),
			"bls": enemy_data["bls"].to_int(),
			"lck_interact": enemy_data["lck_interact"].to_int(),
			"cht": enemy_data["cht"].to_int(),
			"icon": enemy_data["icon"],
			"max_hp": 100, # default value
			"type": "enemy", # default value
			"dice": 6, # default value
			"actions": [] # default empty array
		}

# Función para cargar items desde el archivo .csv
func load_items(file_path: String):
	var data = load_csv(file_path)
	
	for i in range(1, data.size()):
		var item_data = data[i]
		all_items[i] = {
			"name": item_data["name"],
			"description": item_data["description"],
			"function": item_data["function"],
			"type": item_data["type"],
			"icon": item_data["icon"]
		}

# Función para restablecer datos disponibles a su estado inicial
func reset_available_data():
	available_characters.clear()
	available_items_ids.clear()
	
	# Agregar los primeros 3 personajes a los disponibles
	var data = load_csv("res://resources/data/characters.csv")
	for i in range(min(3, data.size())):
		available_characters.append(all_characters[i])

# Función para inicializar la carga de todos los datos
func load_all_data():
	load_characters("res://resources/data/characters.csv")
	load_enemies("res://resources/data/enemies.csv")
	load_items("res://resources/data/items.csv")
	reset_available_data()

func _ready():
	load_all_data()
	print_available_data()

func print_available_data():
	print(all_characters[0])
	print(all_enemies)
	print(all_items)
	print_rich("[font_size=16][pulse][color=red]Available Characters:[/color][/pulse][/font_size] ", available_characters)
	print_rich("[font_size=16][pulse][color=red]Available Items:[/color][/pulse][/font_size] ", available_items_ids)
