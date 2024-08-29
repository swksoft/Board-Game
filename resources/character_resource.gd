extends Resource
class_name CharacterResource

@export_category("Identidad")
@export var char_name : String
@export_multiline var description : String
@export var class_char : String
@export var icon : CompressedTexture2D
@export_category("Estadísticas")
@export var max_hp : int
@export_group("Board")
@export_range(1, 6) var agility : int
@export_group("Fight")
@export var defense : int
@export var evasion : int
@export var attack : int
@export var luck_board : int
@export_range(1, 12) var dice : int
@export var actions : Array
@export_group("Encounter")
@export var technique : int
@export var balls : int
@export var luck_interact : int
@export var charisma : int
