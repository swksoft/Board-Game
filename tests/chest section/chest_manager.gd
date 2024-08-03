class_name ChestManager extends Node

signal open_chest
signal load_data

var characters : Array = []
var items : Array = []

func _ready():
	load_data.emit()
