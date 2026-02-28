extends Node2D
class_name HPbuffComponent

@export var is_player = true
@export var hp_buff_amount: float = 1.5

func _ready():
	main_ui.connect("start_battle", buff_hp)
	
	
func buff_hp():
	if is_player:
		main_ui.set_player_hp(int(main_ui.player_hp * hp_buff_amount))
	else:
		main_ui.set_enemy_hp(int(main_ui.enemy_hp * hp_buff_amount))
