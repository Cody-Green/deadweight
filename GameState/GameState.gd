#GameState.gd

#<->System
#   |->GameState

extends Node

var player_cargo 	:float
signal player_cargo_changed(player_cargo)
var player_rotation :float
	
func update_cargo(m) -> void:
	player_cargo += m
	player_cargo_changed.emit(player_cargo)
