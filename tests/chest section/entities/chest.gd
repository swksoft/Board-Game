class_name Chest extends placeable

@export var difficulty: int = 50
@export var item_name: String = "Potion"
@export var fail_message: String = "Has fallado!"
@export var chest_closed_texture: Texture
@export var chest_open_texture: Texture

var sprite: Sprite2D

# Inventario del jugador
var player_inventory = ["llave"]

# Lista de ítems cargada desde el CSV
var items = []
# Lista de personajes cargada desde el CSV
var characters = []

var dic_ejemplo = {} # BORRAR

func _ready():
	#sprite = $Sprite
	#sprite.texture = chest_closed_texture
	
	items = load_csv("res://resources/data/items.csv")
	print("Loaded items: ", items)
	
	characters = load_csv("res://resources/data/characters.csv")
	print("Loaded characters: ", characters)

func open_chest(character_name: String):
	# Buscar al personaje por nombre
	var character_data = find_character(character_name)
	
	if character_data == null:
		display_message("Personaje no encontrado")
		return

	# Verificar si el jugador tiene una llave
	if "key" in player_inventory:
		display_message("Has abierto el cofre con la llave y has obtenido: " + item_name)
		sprite.texture = chest_open_texture
		return

	# Calcular probabilidad de éxito basado en las estadísticas del personaje
	var chance = (character_data["agl"].to_int() + character_data["tch"].to_int() + character_data["lck_board"].to_int()) / 3
	if chance >= difficulty:
		display_message("Has abierto el cofre y has obtenido: " + item_name)
		sprite.texture = chest_open_texture
	else:
		display_message(fail_message)

func display_message(msg: String):
	print(msg)


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
					#print(dict[headers[i]])
					dict[headers[i]] = line[i]
				
				data.append(dict)
			else:
				pass
				#print("línea inválida", line)
		file.close()
		
	return data

func find_character(name: String) -> Dictionary:
	for character in characters:
		if character["name"] == name:
			return character
	return {}
