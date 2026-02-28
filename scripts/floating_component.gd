extends Node2D
class_name FloatingComponent

@export var target_body: RigidBody2D
@export var minimum_weight: float = 1.5
@export var maximum_weight: float = 5
@export var rise_time: float = 2
@export var lower_time: float = 2
@export var max_height: float = 300
@export var min_height: float = 200
@export var height_buffer: float = 100

var lower_tween: Tween
var riser_tween: Tween
var is_rising = false

func is_above_height(height: float):
	return target_body.global_position.y < get_viewport_rect().size.y - height

func _physics_process(delta: float) -> void:
	if is_above_height(max_height):
		is_rising = false
		riser_tween.stop()
		lower_tween.stop()
		target_body.mass = minimum_weight
	elif not is_above_height(min_height):
		is_rising = true
		riser_tween.stop()
		lower_tween.stop()
		target_body.mass = maximum_weight
	elif is_rising and is_above_height(min_height):
		if not lower_tween.is_running():
			riser_tween.stop()
			lower_tween.stop()
			lower_tween.play()
	elif not is_rising and not is_above_height(max_height):
		if not riser_tween.is_running():
			riser_tween.stop()
			lower_tween.stop()
			riser_tween.play()

func _ready():
	target_body.gravity_scale = -1.0
	tween_rise()
	tween_lower()
	lower_tween.stop()
	riser_tween.stop()


func finished_rising():
	riser_tween.stop()


func finished_lowering():
	lower_tween.stop()


func tween_rise():
	riser_tween = create_tween()
	riser_tween.set_ease(Tween.EASE_OUT)
	riser_tween.tween_property(target_body, "mass", maximum_weight, rise_time)
	riser_tween.set_loops(0)
	riser_tween.tween_callback(finished_rising)
	
	
func tween_lower():
	lower_tween = create_tween()
	lower_tween.set_ease(Tween.EASE_OUT)
	lower_tween.tween_property(target_body, "mass", minimum_weight, lower_time)
	lower_tween.set_loops(0)
	lower_tween.tween_callback(finished_lowering)
	
