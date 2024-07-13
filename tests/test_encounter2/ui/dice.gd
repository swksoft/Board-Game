extends TextureRect

@export var number_rect : TextureRect

func init(number):
	var x = 1152-32 + number*32
	number_rect.texture.region = Rect2(x, 1856, 32, 32)
