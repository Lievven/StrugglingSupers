extends Area2D
class_name Projectile


var velocity: Vector2 = Vector2(1, 0)


func _physics_process(delta: float) -> void:
	position += velocity * delta
