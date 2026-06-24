#EmptySpace.gd

#<->System
#   |->EmptySpace

extends Node

var actions :Array = [{"text" : "Move To", "id" : "move_to"}]

func get_menu_actions() -> Array:
	return actions
