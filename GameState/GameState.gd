#GameState.gd

#<->System
#   |->GameState

extends Node

var player_cargo 	:float
signal player_cargo_changed(player_cargo)
var player_rotation :float
#USE: Use this in the clamp logic to determine direction x - y * IN/OUT
enum ZoomDirection { OUT = -1, IN = 1 }
	
func update_cargo(m) -> void:
	player_cargo += m
	player_cargo_changed.emit(player_cargo)
