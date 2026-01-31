extends Control
class_name MainUI


@export var player_hp_label: Label
@export var enemy_hp_label: Label

signal start_battle
signal debug_spawn


func set_player_hp(amount: int):
	player_hp_label.text = "Player: " + str(amount)
	
	
func set_enemy_hp(amount: int):
	enemy_hp_label.text = "Opponent: " + str(amount)




func _on_start_button_pressed() -> void:
	emit_signal("start_battle")


func _on_add_limb_button_pressed() -> void:
	emit_signal("debug_spawn")


func _on_teleport_button_pressed() -> void:
	pass
		
		
func _teleport(node, target: Vector2 = Vector2(0, 0)):
	if not (node is RigidBody2D or node is DragJoint):
		return
	
	for n in node.get_children():
		_teleport(n)
	
	node.position = target
