extends Area2D
class_name DamageComponent

signal damage_dealt

@export var free_on_damage: Node2D = null
@export var damage_delay_timer: float = 0
@export var damage_amount: int = 10
@export var damage_player: bool = false

var delay_timer = 0
var bodies = []

func _physics_process(delta: float) -> void:
	if delay_timer > 0:
		delay_timer -= delta
		return
	if bodies.size() <= 0:
		return
	
	damage_dealt.emit(bodies[0])
	delay_timer = damage_delay_timer
	if damage_player:
		main_ui.damage_player(damage_amount)
	else:
		main_ui.damage_enemy(damage_amount)
	
	if free_on_damage:
		free_on_damage.queue_free()


func set_target(is_target_player: bool = false):
	if is_target_player:
		set_collision_mask_value(9, true)
		damage_player = true
	else:
		set_collision_mask_value(17, true)
		damage_player = false


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage_collision"):
		if not body.damage_collision(get_parent()):
			return
	bodies.append(body)
	


func _on_body_exited(body: Node2D) -> void:
	bodies.erase(body)
