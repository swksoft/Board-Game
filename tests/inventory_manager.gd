@icon("res://icons/box_icon1.svg")
extends Node

@export var inventory_size = 8

var inventory = []
var num_items = 0

func _init_inventory(size: int):
	inventory = []
	for i in range(size):
		inventory.append(null)

func add_item(item_index: int):
	if num_items < inventory_size:
		for i in range(inventory.size()):
			if inventory[i] == null:
				inventory[i] = item_index
				num_items += 1
				break
	else:
		printerr("Inventario lleno")

func remove_item(item_index: int):
	if num_items != 0:
		for i in range(inventory.size()):
			if inventory[i] == item_index:
				inventory[i] = null
				num_items -= 1
				break

func print_inventory():
	for i in range(inventory.size()):
		if inventory[i] != null:
			print("Casilla ", i, ": ", GlobalDataTest.all_items[inventory[i]]["name"])
		else:
			print("Casilla ", i, ": Vacío")

func _ready():
	_init_inventory(inventory_size)
	
	## Añadir
	#add_item(0)
	#add_item(1)
	#add_item(2)
	#add_item(2)
	#print("Añadir:\n")
	#print_inventory()
	#
	## Quitar
	#remove_item(1)
	#print("Quitar:\n")
	#print_inventory()
