extends TextureRect

@export var char_resource : CharacterResource

func set_data(resource: CharacterResource):
	char_resource = resource
	
	if char_resource != null:
		texture = char_resource.icon
	else:
		texture = null
