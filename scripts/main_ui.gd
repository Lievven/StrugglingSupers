extends Control
class_name MainUI


@export var inventory: Inventory

@export var player_hp_label: ProgressBar
@export var enemy_hp_label: ProgressBar
@export var lives_label: Label
@export var level_time: int = 120
@export var time_display: Label
@export var default_lives: int = 3

@onready var remaining_time = level_time
var millis = 0

var player_hp = 100
var enemy_hp = 100
@onready var lives = default_lives

var game_playing = true
var game_paused = true
var won = true

var enemy_controller: EnemyController

signal start_battle
signal debug_spawn


func _ready() -> void:
	time_display.text = "Time : " + str(remaining_time) + "s"


func _process(delta: float) -> void:
	advance_timer(delta)

func advance_timer(delta):
	if game_paused:
		return
	
	millis += delta
	if remaining_time <= 0 and millis >= 1:
		if enemy_hp > 0:
			lose_round()
		return
	
	if millis >= 1.0:
		millis -= 1
		remaining_time -= 1
		time_display.text = "Time : " + str(remaining_time) + "s"
		
	


func damage_player(amount: int):
	if game_paused:
		return
	player_hp -= amount
	set_player_hp(player_hp)


func damage_enemy(amount: int):
	if game_paused:
		return
	enemy_hp -= amount
	set_enemy_hp(enemy_hp)

func win_round():
	won = true
	game_paused = true
	spawn_game_outcome("Foe Slain!")

func lose_round():
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



func set_inventory_visibility(is_visible):
	$Inventory.visible = is_visible
	$ControlButtons.visible = is_visible


func reset_level():
	remaining_time = level_time
	set_player_hp(100)
	set_enemy_hp(100)
	remaining_time = level_time
	time_display.text = "Time : " + str(remaining_time) + "s"
	enemy_controller.reset_level(won)
	$Inventory.reset_level()
	set_inventory_visibility(true)
		


func reset_game():
	game_playing = true
	enemy_controller.reset_game()
	reset_level()
	lives = default_lives
	lives_label.text = "Lives: " + str(lives)
	inventory.initial_generation()


func _teleport(node, target: Vector2 = Vector2(0, 0)):
	if not (node is RigidBody2D or node is DragJoint):
		return
	
	for n in node.get_children():
		_teleport(n)
	
	node.position = target



func game_over(won: bool = false):
	if not game_playing:
		return
	game_playing = false
	if won:
		spawn_game_outcome("You Win!")
	else:
		spawn_game_outcome("Game Over.")


func _on_start_button_pressed() -> void:
	set_inventory_visibility(false)
	game_paused = false
	emit_signal("start_battle")


func _on_add_limb_button_pressed() -> void:
	$Inventory.generate_new_part_buttons()


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
