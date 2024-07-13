class_name DiceManager extends Node

signal dice_thrown(result, user)

func throw_dice(faces = 6, user = null):
	var rng = RandomNumberGenerator.new()
	var number = ceil(rng.randf_range(0, faces))
	dice_thrown.emit(number, user)
	return number
