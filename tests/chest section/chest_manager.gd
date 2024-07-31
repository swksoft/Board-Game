class_name ChestManager extends Node

signal open_chest
signal load_data

var characters : Array = []
var items : Array = []

func _ready():
	characters = EventsTest.load_csv("res://resources/data/characters.csv")
	items = EventsTest.load_csv("res://resources/data/items.csv")
	
	load_data.emit()
	
