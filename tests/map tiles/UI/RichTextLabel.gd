extends RichTextLabel

var turn_icon : String = "[img=16x16 region=832,1600,32,32]res://maps/assets/ProjectUtumno_full.png[/img]"

var turns_max : int
var current_turn : int

func turns_draw():
	clear()
	
	append_text("TIEMPO ")
	
	for turns in current_turn:
		append_text(turn_icon)

# PROVISIONAL
func _ready():
	EventsTest.end_turn_board.connect(_on_end_turn)
	
	# EXAMPLE
	turns_max = 28
	current_turn = turns_max
	
	turns_draw()

func pass_turn():
	current_turn -= 1
	
	if current_turn <= 0:
		current_turn = 0
		game_over()
	
	turns_draw()
	
func game_over():
	# TODO: PANTALLA GAME OVER + motivo de pérdida}
	print(" GAME OVER (0 turnos restantes)")
	
func _on_end_turn():
	pass_turn()
