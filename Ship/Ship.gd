extends Node2D

var target_position = Vector2(0, 0)
var speed = 100
var stopping_threshold = 0.9

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("set_target"):
		target_position = get_global_mouse_position()
	rotation = atan2(target_position.y - position.y, target_position.x - position.x)
	if (target_position - position).length() >= stopping_threshold:
		position += speed * Vector2(cos(rotation), sin(rotation)) * delta
