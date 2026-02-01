extends Node2D
class_name Projectile

@export var damage_component: DamageComponent

var velocity: Vector2 = Vector2(1, 0)


func _physics_process(delta: float) -> void:
	position += velocity * delta


func set_lifetime(time: float):
	$Timer.start(time)


func _on_timer_timeout() -> void:
	self.queue_free()
