#AsteroidSpawner.gd

#<->AsteroidSpawner

extends Node

var asteroid 				:= preload("res://Asteroid/Asteroid.tscn")
var position_min 			: float 	= -200.0
var position_max 			: float 	=  200.0
var field_position_min 		: float 	= -2000.0
var field_position_max 		: float 	=  2000.0
var field_position			: Vector2 	=  Vector2.ZERO
var num_asteroids	 		: int		=  25
var num_fields				: int		=  3
var asteroid_buffer			: float		=  0.005

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	field_position += Vector2(randf_range(field_position_min, field_position_max), randf_range(field_position_min, field_position_max))
	for i in range(num_fields):
		seed_field(field_position)
		field_position += Vector2(randf_range(field_position_min, field_position_max), randf_range(field_position_min, field_position_max))

func seed_field(_field_position: Vector2) -> void:
	var accepted_positions : Array[Vector2]
	var max_rolls = 500

	for i_asteroid in range(num_asteroids):
		for i_roll in range(max_rolls):
			var candidate_position = _field_position + Vector2(randf_range(position_min, position_max), randf_range(position_min, position_max))
			var position_is_valid = true
			for accepted_position in accepted_positions:
				if (candidate_position - accepted_position).length() <= (GameState.asteroid_max_radius * 2) * (1.0 + asteroid_buffer):
					position_is_valid = false
					break
			if position_is_valid:
				accepted_positions.append(candidate_position)
				var new_asteroid = asteroid.instantiate()
				new_asteroid.position = candidate_position
				#new_asteroid.add_to_group("NAME_OF_GROUP")
				get_parent().add_child.call_deferred(new_asteroid)
				break
