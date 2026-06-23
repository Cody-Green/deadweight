#CollectibleCursorMenu

#<->CollectibleCursorMenu

extends Control

var panel_minimum_x :float = 80
var panel_minimum_y :float = 120

func _ready() -> void:
	$Panel.custom_minimum_size = Vector2(panel_minimum_x, panel_minimum_y) 
