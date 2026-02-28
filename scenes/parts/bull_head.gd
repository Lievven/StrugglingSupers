extends RigidBody2D

@export var damage_component: DamageComponent

func _ready() -> void:
	damage_component.connect("damage_dealt", jolt_on_hit)


func jolt_on_hit(body):
	#var vec = Vector2.UP.rotated(global_rotation)
	var pos = $AnimatedComponent.position
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property($AnimatedComponent, "position", pos + Vector2(0, -50), 0.15)
	tween.tween_property($AnimatedComponent, "position", pos, 0.15)
	tween.tween_callback(tween.kill)
	
	if body is RigidBody2D:
		var angle = global_position.angle_to_point(body.global_position)
		var direction = Vector2.from_angle(angle)
		body.apply_impulse(direction * 1000)
