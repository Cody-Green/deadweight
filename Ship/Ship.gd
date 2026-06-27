#Ship.gd

#<->Ship

extends Node2D

var target_position 	:Vector2 = Vector2(0, 0)
var speed				:int = 400
var stopping_threshold 	:float = 10
var orbit_distance 		:float = 0.0
var orbit_speed 		:float = 0.0
var orbital_angle 		:float = 0.0
var orbit_center 		:Vector2 = Vector2(0, 0)
var is_orbiting 		:bool  = false
var hull_length :float = 64.0
var hull_width :float = 32.0
var notch_scale :float = 0.28

func _ready() -> void:
	rotation = GameState.player_rotation
	$Hull.set_hull(hull_length, hull_width, notch_scale)

func _process(delta: float) -> void:
	
	if (target_position - position).length() > 0.05:
		rotation = atan2(target_position.y - position.y, target_position.x - position.x)
		#Ship moves by the smaller distance of physics step (speed * delta) and remaining distance ((target_position - position).length()
		position += Vector2(cos(rotation), sin(rotation)) * min(speed * delta, (target_position - position).length())
		GameState.player_rotation = rotation
		
	if is_orbiting:
		orbital_angle += orbit_speed * delta
		target_position = orbit_center + Vector2(cos(orbital_angle), sin(orbital_angle)) * orbit_distance
		
func set_target_position(pos: Vector2) -> void:
	is_orbiting = false
	target_position = pos

func set_orbit(orbit_distance, orbit_speed: float, object_position: Vector2) -> void:
		var direction_to_ship = position - object_position
		orbital_angle = direction_to_ship.angle()
		orbit_center = object_position
		self.orbit_distance = orbit_distance
		self.orbit_speed = orbit_speed
		self.orbital_angle = orbital_angle
		is_orbiting = true

func _draw() -> void:
	if GameState.debug:
		pass #draw_line(Vector2($Hull.hull_length/2, -$Hull.hull_width/2), Vector2($Hull.hull_length/2, $Hull.hull_width/2), Color(0xff00ff67), 1, true)
