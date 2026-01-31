extends Sprite2D

var tween

func _ready() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_rotation_degrees", 360, 0.5).from_current()
	tween.set_loops()
	tween.bind_node(self)
