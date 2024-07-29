class_name StatChest extends Node

signal icon_ready

@export_category("Identity")
@export var character_name : String
@export var character_class : String
@export var icon : String
@export_category("General")
@export var max_hp : int
@export var type : String
@export var dice : int
@export var actions : Array
@export_category("Stats In-Battle")
@export var attack : int
@export var evasion : int
@export var defense : int
@export_category("Stats In-Board")
@export var luck_board : int
@export var technique : int
@export var agility : int
@export_category("Stats In-Chat")
@export var balls : int
@export var luck_interact : int
@export var charisma : int

var hp : int
var character_data = null

func assign_data(data: Dictionary):
	character_name = data["name"]
	character_class = data["class"]
	attack = int(data["atk"])
	evasion = int(data["eva"])
	defense = int(data["def"])
	luck_board = int(data["lck_board"])
	technique = int(data["tch"])
	agility = int(data["agl"])
	balls = int(data["bls"])
	luck_interact = int(data["lck_interact"])
	charisma = int(data["cht"])
	icon = data["icon"]
	emit_signal("icon_ready")
	# TODO: AGREGAR RESTO

func _ready():
	character_data = load_stats("res://resources/data/characters.csv", character_name)
	if character_data:
		#print(character_data)
		assign_data(character_data)

func load_stats(file_path: String, character_name: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var data = {}

	if file.file_exists(file_path):
		file.open(file_path, FileAccess.READ)
		
		var headers = file.get_csv_line()
		
		while not file.eof_reached():
			var line = file.get_csv_line()
			
			if line.size() != headers.size():
				continue
			
			if line[0] == character_name:
				for i in range(headers.size()):
					data[headers[i]] = line[i]
				break
				
		file.close()
		
	else: pass#print("error: ", file_path)

	return data
