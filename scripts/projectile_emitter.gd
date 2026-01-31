extends Marker2D
class_name ProjectileEmitter

@export var shot_delay: float = 1.0
@export var shot_speed: float = 300.0
@export var projectile_scene: PackedScene
@export_flags_2d_physics var projectile_collision_flags

func _ready() -> void:
	main_ui.connect("start_battle", _start_battle)

func _start_battle():
	$Timer.start(shot_delay)


func _on_timer_timeout() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.position = global_position
	var angle = global_rotation + randf_range(-0.2, 0.2)
	projectile.velocity = Vector2.from_angle(angle) * shot_speed
	get_tree().root.add_child(projectile)
