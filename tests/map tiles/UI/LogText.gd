class_name TextLog extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	EventsTest.board_message_display.connect(on_message_display)
	
func on_message_display(text: String):
	append_text(text + "\n")
