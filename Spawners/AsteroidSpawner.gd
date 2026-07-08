#AsteroidSpawner.gd

#<->AsteroidSpawner

extends Node

var asteroid 			:= preload("res://Asteroid/Asteroid.tscn")
var position_min 			: float 	= -200.0
var position_max 			: float 	=  200.0
var field_position_min 		: float 	= -2000.0
var field_position_max 		: float 	=  2000.0
var field_position			: Vector2 	=  Vector2.ZERO
var num_asteroids	 		: int		=  50
var num_fields				: int		=  3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(num_fields):
		seed_field(field_position)
		field_position += Vector2(randf_range(field_position_min, field_position_max), randf_range(field_position_min, field_position_max))

func seed_field(_field_position: Vector2) -> void:
	for i in range(num_asteroids):
		var new_asteroid = asteroid.instantiate()
		new_asteroid.add_to_group("collectibles")
		new_asteroid.position = _field_position + Vector2(randf_range(position_min, position_max), randf_range(position_min, position_max))
		get_parent().add_child.call_deferred(new_asteroid)
