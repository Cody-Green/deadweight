#Ship.gd

#<->Ship

extends Node2D

var orbit_center 			:Vector2 = Vector2(0, 0)
var target_position 		:Vector2 = Vector2(0, 0)

var speed					:int = 400
var target_angle 			:float = 0.0
var turn_speed 				:float = 5

var hull_length 			:float = 64.0
var hull_width 				:float = 32.0
var notch_scale 			:float = 0.28

var rotation_epsilon 		:float = pow(10, -5)
var stopping_epsilon 		:float = pow(10, -5)

var orbital_angle 			:float = 0.0
var is_orbiting 			:bool  = false
var orbit_distance 			:float = 200.0
var orbit_speed 			:float = 3.0

#TEMPORARY: MINING VARIABLES - To be replaced by modules in the future
var mining_target			:Object
var mining_laser_cycle		:int   = 2
var time_since_last_cycle 	:float = 0
var is_mining				:bool  = false
var mining_range			:float = 200.0

#TEMPORARY: TRACTOR BEAM VARIABLES - To be replaced by modules in the future
var tractor_beam_targets	:Array = []
var tractor_beam_range		:float = 200.0
var tractor_beam_speed		:float = 80.0
var number_of_tractor_beams	:int = 3

# --- debug trail ---
var trail_points : Array[Vector2] = []
const TRAIL_MAX  := 2000 
const TRAIL_GAP  := 25

func _ready() -> void:
	rotation = GameState.player_rotation
	target_position = GameState.player_position
	position = GameState.player_position
	$Hull.set_hull(hull_length, hull_width / 2, notch_scale)
	$CollisionArea/CollisionShape.set_collision_shape(Vector2(0, 0), Vector2(-hull_length, -hull_width / 2), Vector2(-hull_length, hull_width / 2))

func _process(delta: float) -> void:
	if is_orbiting:
		orbit_target(delta)
	else:
		move_to_target(delta)

	if GameState.debug:
		if trail_points.is_empty() or global_position.distance_to(trail_points[-1]) >= TRAIL_GAP:
			trail_points.append(global_position)
			if trail_points.size() > TRAIL_MAX:
				trail_points.pop_front()
		queue_redraw()

	if is_mining:
		if not is_instance_valid(mining_target):
			is_mining = false
		elif self.global_position.distance_to(mining_target.global_position) <= mining_range:
			time_since_last_cycle += delta
			if time_since_last_cycle >= mining_laser_cycle:
				time_since_last_cycle = 0
				mining_pulse()

func set_target_position(pos: Vector2) -> void:
	is_orbiting = false
	target_position = pos

func set_orbit(object_position: Vector2) -> void:
		orbit_center = object_position
		orbital_angle = (position - orbit_center).angle()
		var heading := Vector2(cos(rotation), sin(rotation))
		orbit_speed = abs(orbit_speed) * signf((position - orbit_center).cross(heading))
		target_position = orbit_center + Vector2(cos(orbital_angle), sin(orbital_angle)) * orbit_distance
		is_orbiting = true

func move_to_target(delta: float) -> void:
	var to_target_vector := target_position - position
	if to_target_vector.length() <= stopping_epsilon:
		return
	target_angle = to_target_vector.angle()
	rotation = rotate_toward(rotation, target_angle, turn_speed * delta)
	if abs(angle_difference(rotation, target_angle)) < rotation_epsilon:
		position += Vector2(cos(rotation), sin(rotation)) * min(speed * delta, to_target_vector.length())
		GameState.player_position = position
		GameState.player_rotation = rotation
		
func orbit_target(delta: float) -> void:
	orbital_angle += orbit_speed * delta
	target_position = orbit_center + Vector2(cos(orbital_angle), sin(orbital_angle)) * orbit_distance
	var to_point := target_position - position
	rotation = rotate_toward(rotation, to_point.angle(), turn_speed * delta)
	position += to_point.normalized() * min(speed * delta, to_point.length())
	GameState.player_position = position
	GameState.player_rotation = rotation
	
func initiate_mining(target) -> void:
	if self.global_position.distance_to(target.global_position) > mining_range:
		set_target_position(
				global_position +
				(target.global_position - self.global_position).normalized() * 
				((target.global_position - self.global_position).length() - (mining_range - 5)))
	mining_target = target
	is_mining = true

func mining_pulse() -> void:
	mining_target.extract_ore_chunk()

func _draw() -> void:
	if not GameState.debug or trail_points.size() < 2:
		return
	var pts : PackedVector2Array = []
	for p in trail_points:
		pts.append(to_local(p))
	draw_polyline(pts, Color(0.2, 0.9, 1.0, 0.6), 2.0, true)
	for lp in pts:
		draw_circle(lp, 2.0, Color(1.0, 1.0, 0.3, 0.85))
