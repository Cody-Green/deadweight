#GameState.gd

#<->System
#   |->GameState

extends Node

var player_cargo 	:float
signal player_cargo_changed(player_cargo)
var player_rotation :float
var debug :bool = true
#USE: 
#Scale the zoom result by ZoomDirection
#Example: zoom_level + zoom_step * direction
enum ZoomDirection { OUT = -1, IN = 1 }

func update_cargo(m) -> void:
	player_cargo += m
	player_cargo_changed.emit(player_cargo)
