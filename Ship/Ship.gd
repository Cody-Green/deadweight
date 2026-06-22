#Ship.gd

#<->Ship

extends Node2D

var target_position 	:Vector2 = Vector2(0, 0)
var speed				:int = 400
var stopping_threshold 	:float = 5
var zoom_step			:float = 0.1
var zoom_level			:float = 0.6

func _ready() -> void:
	$Camera2D.zoom = Vector2(zoom_level, zoom_level)
	rotation = GameState.player_rotation

func _process(delta: float) -> void:
	
	if (target_position - position).length() >= stopping_threshold:
		rotation = atan2(target_position.y - position.y, target_position.x - position.x)
		position += speed * Vector2(cos(rotation), sin(rotation)) * delta
		GameState.player_rotation = rotation
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom_level = clamp(zoom_level + zoom_step, 0.4, 0.8)
		$Camera2D.zoom = Vector2(zoom_level, zoom_level)
		
	if Input.is_action_just_pressed("zoom_out"):
		zoom_level = clamp(zoom_level - zoom_step, 0.4, 0.8)
		$Camera2D.zoom = Vector2(zoom_level, zoom_level)
		
func set_target_position(pos: Vector2) -> void:
	target_position = pos
