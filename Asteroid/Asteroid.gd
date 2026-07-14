#Asteroid.gd

extends Node2D

var asteroid_vertices		: PackedVector2Array
var asteroid_resolution		: int
var asteroid_min_radius		: float
var asteroid_max_radius		: float
var actions					: Array = [{"text" : "Approach", "id" : "approach"}, {"text" : "Mine", "id" : "mine"}, {"text" : "Orbit", "id" : "orbit"}]

var ore_chunk	 			:= preload("res://Collectible/Collectible.tscn")
var ore_mass_min			: float = 100 #Temporary: currently set to match ore_mass_max for testing; current intention is to possibly calculate this in the future
var ore_mass_max			: float = 100 #Temporary: currently set to match ore_mass_max for testing; current intention is to possibly calculate this in the future
var ore_mass				: float
var ore_yield_min			: float = 25 #Temporary: currently set to match ore_yield_max for testing
var ore_yield_max			: float = 25 #Temporary: currently set to match ore_yield_min for testing
var ore_yeild				: float #Temporary: this will be determined by the module and passed in through the ship in the future

func _ready() -> void:
	asteroid_resolution = GameState.asteroid_resolution
	asteroid_min_radius = GameState.asteroid_min_radius
	asteroid_max_radius = GameState.asteroid_max_radius
	ore_mass = randf_range(ore_mass_min, ore_mass_max)
	
	for vertex in asteroid_resolution:
		var step_angle : float = vertex * TAU / asteroid_resolution
		var radius : float = randf_range(asteroid_min_radius, asteroid_max_radius)
		asteroid_vertices.append(Vector2(cos(step_angle), sin(step_angle)) * radius)

	$AsteroidShape.polygon = asteroid_vertices
	$CollisionArea/CollisionShape.polygon = asteroid_vertices

func get_menu_actions() -> Array:
	return actions

func extract_ore_chunk() -> void:
	ore_yeild = randf_range(ore_yield_min, ore_yield_max)
	ore_mass -= min(ore_yeild, ore_mass)
	var new_ore_chunk = ore_chunk.instantiate()
	new_ore_chunk.mass = ore_yeild
	new_ore_chunk.position = self.global_position + (GameState.player_position - self.global_position).normalized() * (GameState.player_position - self.global_position).length()
	get_parent().add_child.call_deferred(new_ore_chunk)
	if ore_mass <= 0:
		queue_free()
	
	
