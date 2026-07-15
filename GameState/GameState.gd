#GameState.gd

#<->System
#   |->GameState

extends Node

signal player_cargo_changed(player_cargo)
var player_cargo 	: float
var player_rotation : float
var player_position : Vector2 = Vector2.ZERO

var zoom			: Vector2 = Vector2.ZERO

var debug :bool = true

var asteroid_resolution		: int = 12
var asteroid_min_radius		: float = 40.0 / 2.0
var asteroid_max_radius		: float = 40.0

var viewport_rect_size		: Vector2

#USE: 
#Scale the zoom result by ZoomDirection
#Example: zoom_level + zoom_step * direction
enum ZoomDirection { OUT = -1, IN = 1 }

func update_cargo(m) -> void:
	player_cargo += m
	player_cargo_changed.emit(player_cargo)
