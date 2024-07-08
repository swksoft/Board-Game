extends TextureProgressBar

@export var stat_node : NodePath

@onready var stat = get_node(stat_node)

var hp

func _ready():
	hp = stat.max_health
	max_value = hp
	value = hp
	
	
