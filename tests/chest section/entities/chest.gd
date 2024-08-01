class_name Chest extends placeable

signal show_options(char_stats)

@export var chest_stats : StatChest
@export var fail_message: String = "Has fallado!"
@export var chest_closed_texture: Texture
@export var chest_open_texture: Texture

var sprite: Sprite2D

#var character = Character_Treasure

# Inventario del jugador
var player_inventory = ["shit"]
var items = []
var characters = []
var dic_ejemplo = {} # BORRAR
var opening = false

func _ready():
	EventsTest.open_chest.connect(_on_open_chest)
	EventsTest.cancel_open_chest.connect(_on_chest_left)
	
	sprite = $Sprite2D
	sprite.texture = chest_closed_texture
	
	items = EventsTest.load_csv("res://resources/data/items.csv")
	characters = EventsTest.load_csv("res://resources/data/characters.csv")

func open_chest(character_name: String):
	## Buscar al personaje por nombre
	var character_data = find_character(character_name)
	
	if character_data == null:
		#display_message("Personaje no encontrado")
		print("Personaje no encontrado")
		return
#
	## Verificar si el jugador tiene una llave
	if "key" in player_inventory:
		print("Has abierto el cofre con la llave y has obtenido: " , chest_stats.item_name)#display_message("Has abierto el cofre con la llave y has obtenido: " + item_name)
		#sprite.texture = chest_open_texture
		return
#
	## Calcular probabilidad de éxito basado en las estadísticas del personaje
	var chance = (character_data["lck_board"].to_int() + character_data["tch"].to_int() / 3 )
	print(chance)
	if chance >= chest_stats.difficulty:
		print("Has abierto el cofre y has obtenido: " , chest_stats.item_name)
		sprite.texture = chest_open_texture
	else:
		print(fail_message)

func find_character(name: String) -> Dictionary:
	for character in characters:
		if character["name"] == name:
			print_debug(character)
			return character
	return {}
	
func _on_open_chest(char_stats):
	opening = true
	print(char_stats["name"], " abrirá el cofre.")
	emit_signal("show_options", char_stats)
	EventsTest.emit_chest_entered()

func _on_chest_left():
	opening = false
