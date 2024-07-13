extends PanelContainer

@export var name_label : Label
@export var hp_label : Label
@export var atk_label : Label
@export var dfs_label : Label
@export var eva_label : Label

var char

func init(coming_char):
	#coming_char.stat_changed.connect(update)
	char = coming_char
	update()
	pass
	
func update():
	name_label.text = char.name
	hp_label.text = str(char.hp)
	atk_label.text = str(char.atk)
	dfs_label.text = str(char.dfs)
	eva_label.text = str(char.eva)
