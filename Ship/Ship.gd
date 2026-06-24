#Ship.gd

#<->Ship

extends Node2D

var target_position 	:Vector2 = Vector2(0, 0)
var speed				:int = 400
var stopping_threshold 	:float = 10
var zoom_step			:float = 0.1
var zoom_level			:float = 0.6
var orbit_distance 		:float = 0.0
var orbit_speed 		:float = 0.0
var orbital_angle 		:float = 0.0
var is_orbiting 		:bool  = false


func _ready() -> void:
	$Camera2D.zoom = Vector2(zoom_level, zoom_level)
	rotation = GameState.player_rotation

func _process(delta: float) -> void:
	
	if (target_position - position).length() >= stopping_threshold:
		rotation = atan2(target_position.y - position.y, target_position.x - position.x)
		position += speed * Vector2(cos(rotation), sin(rotation)) * delta
		GameState.player_rotation = rotation
		
	if is_orbiting:
		orbital_angle += orbit_speed * delta
		target_position = target_position + Vector2(cos(orbital_angle), sin(orbital_angle)) * orbit_distance
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom_level = clamp(zoom_level + zoom_step, 0.4, 0.8)
		$Camera2D.zoom = Vector2(zoom_level, zoom_level)
		
	if Input.is_action_just_pressed("zoom_out"):
		zoom_level = clamp(zoom_level - zoom_step, 0.4, 0.8)
		$Camera2D.zoom = Vector2(zoom_level, zoom_level)
		
func set_target_position(pos: Vector2) -> void:
	target_position = pos

func set_orbit(orbit_distance, orbit_speed: float, object_position: Vector2) -> void:
		var direction_to_ship = position - object_position
		orbital_angle = direction_to_ship.angle()
		target_position = object_position
		self.orbit_distance = orbit_distance
		self.orbit_speed = orbit_speed
		self.orbital_angle = orbital_angle
		is_orbiting = true
