extends Marker2D
class_name ImpulseComponent

@export var impulse_force: float = 50.0
@export var impulse_delay: float = 0.5

@onready var parent = get_parent()

signal giving_impulse

func _ready() -> void:
	main_ui.connect("start_battle", start_battle)
	
func start_battle():
	$Timer.start(impulse_delay)

func _on_timer_timeout() -> void:
	if parent is RigidBody2D:
		var impulse = Vector2(0, -1).rotated(global_rotation) * impulse_force
		parent.apply_impulse(impulse)
		giving_impulse.emit()
