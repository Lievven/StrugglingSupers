extends Node2D
class_name EnemyController

@export var enemies: Array[PackedScene]

var enemy_index = 0
var active_enemy = null


func _ready() -> void:
	main_ui.enemy_controller = self
	reset_level(false)


func reset_game():
	enemy_index = -1

func reset_level(won: bool):
	if won:
		enemy_index += 1
		
	if enemy_index >= enemies.size():
		main_ui.game_over(true)
		return
	if active_enemy:
		remove_child(active_enemy)
	
	active_enemy = enemies[enemy_index].instantiate()
	add_child(active_enemy)
