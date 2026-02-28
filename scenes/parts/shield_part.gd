extends RigidBody2D

@export var knockback_cooldown: float = 2.0
var last_knockback = 0

func _physics_process(delta: float) -> void:
	last_knockback -= delta


func damage_collision(collision_object):
	if collision_object is RigidBody2D:
		if last_knockback > 0:
			return false
		last_knockback = knockback_cooldown
		var angle = global_position.angle_to_point(collision_object.global_position)
		var direction = Vector2.from_angle(angle)
		collision_object.apply_impulse(direction * 1000)
	elif collision_object.velocity is Vector2 and collision_object.velocity.length() > 0:
		var angle = global_position.angle_to_point(collision_object.global_position)
		var direction = Vector2.from_angle(angle)
		collision_object.velocity = direction * collision_object.velocity.length()
		
	return false
