extends AnimatedComponent

@export var impulse_component: ImpulseComponent
@export var timer: Timer

func _ready() -> void:
	play()
	impulse_component.connect("giving_impulse", impulse_given)
	


func impulse_given():
	self.visible = true
	timer.start()


func impulse_ends():
	self.visible = false
