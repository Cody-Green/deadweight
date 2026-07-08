#Asteroid.gd

extends Node2D

var asteroid_vertices		: PackedVector2Array
var asteroid_resolution		: int
var asteroid_min_radius		: float
var asteroid_max_radius		: float

func _ready() -> void:
	var asteroid_resolution = GameState.asteroid_resolution
	var asteroid_min_radius = GameState.asteroid_min_radius
	var asteroid_max_radius = GameState.asteroid_max_radius
	
	for vertex in asteroid_resolution:
		var step_angle : float = vertex * TAU / asteroid_resolution
		var radius : float = randf_range(asteroid_min_radius, asteroid_max_radius)
		asteroid_vertices.append(Vector2(cos(step_angle), sin(step_angle)) * radius)

	$AsteroidShape.polygon = asteroid_vertices
	$Area2D/CollisionShape.polygon = asteroid_vertices
