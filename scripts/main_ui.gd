extends Control
class_name MainUI


@export var inventory: Inventory

@export var player_hp_label: ProgressBar
@export var enemy_hp_label: ProgressBar
@export var lives_label: Label
var player_hp = 100
var enemy_hp = 100
var lives = 3

var game_playing = true
var game_paused = false
var won = true


var enemy_controller: EnemyController

signal start_battle
signal debug_spawn


func damage_player(amount: int):
	player_hp -= amount
	set_player_hp(player_hp)
	
func damage_enemy(amount: int):
	enemy_hp -= amount
	set_enemy_hp(enemy_hp)

func win_round():
	won = true
	spawn_game_outcome("Foe Slain!")

func lose_round():
	if game_paused:
		return
	won = false
	game_paused = true
	lives -= 1
	if lives == 0:
		game_over()
		return
	lives_label.text = "Lives: " + str(lives)
	spawn_game_outcome("Disaster!")


func set_player_hp(amount: int):
	player_hp = amount
	if player_hp_label.max_value < amount:
		player_hp_label.max_value = amount
	player_hp_label.value = amount
	if player_hp <= 0 and enemy_hp > 0:
		lose_round()
	
	
func set_enemy_hp(amount: int):
	enemy_hp = amount
	if enemy_hp_label.max_value < amount:
		enemy_hp_label.max_value = amount
	enemy_hp_label.value = amount
	if enemy_hp <= 0:
		win_round()




func reset_level():
	game_paused = false
	set_player_hp(100)
	set_enemy_hp(100)
	enemy_controller.reset_level(won)
	$Inventory.reset_level()
		
		
func _teleport(node, target: Vector2 = Vector2(0, 0)):
	if not (node is RigidBody2D or node is DragJoint):
		return
	
	for n in node.get_children():
		_teleport(n)
	
	node.position = target


func reset_game():
	pass


func game_over(won: bool = false):
	game_playing = false
	if won:
		spawn_game_outcome("You Win!")
	else:
		spawn_game_outcome("Game Over.")


func _on_start_button_pressed() -> void:
	emit_signal("start_battle")


func _on_add_limb_button_pressed() -> void:
	emit_signal("debug_spawn")


func _on_teleport_button_pressed() -> void:
	reset_level()

func spawn_game_outcome(new_text: String):
	$GameOutcomeButton.visible = true
	$GameOutcomeButton.text = new_text
	


func _on_game_outcome_button_pressed() -> void:
	$GameOutcomeButton.visible = false
	if game_playing:
		reset_level()
	else:
		reset_game()
