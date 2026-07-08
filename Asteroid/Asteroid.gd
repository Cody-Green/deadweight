#Asteroid.gd

extends Node2D

var asteroid_vertices		: PackedVector2Array
var asteroid_resolution		: int = 12
var asteroid_min_radius		: float = 40.0 / 2.0
var asteroid_max_radius		: float = 40.0
var widest_radius			: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for vertex in asteroid_resolution:
		var step_angle : float = vertex * TAU / asteroid_resolution
		var radius : float = randf_range(asteroid_min_radius, asteroid_max_radius)
		widest_radius = maxf(widest_radius, radius)
		asteroid_vertices.append(Vector2(cos(step_angle), sin(step_angle)) * radius)

	$AsteroidShape.polygon = asteroid_vertices
	$Area2D/CollisionShape.polygon = asteroid_vertices
