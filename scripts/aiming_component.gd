extends Marker2D

@export var aiming_part: RigidBody2D
@export var joint: DragJoint
var enemy: RigidBody2D

func _ready() -> void:
	main_ui.connect("start_battle", start_battle)
	
func start_battle():
	if joint.is_player:
		var e: Node2D = main_ui.enemy_controller.active_enemy
		enemy = e.find_child("BasePart")
	else:
		enemy = main_ui.inventory.spawn_controller.parent_body
	
func _physics_process(delta: float) -> void:
	if not enemy:
		return
		
	var target_position = enemy.global_position
	var target_angle = get_angle_to(target_position)
	aiming_part.apply_torque(target_angle * joint.physics_force)
