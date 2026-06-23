#CollectibleCursorMenu

#<->CollectibleCursorMenu

extends Control

signal action_chosen(action, target)
var target :Object

func _ready() -> void:
	$PanelContainer/VBoxContainer/Approach.pressed.connect(_on_action_button_pressed.bind("approach"))
	$PanelContainer/VBoxContainer/Collect.pressed.connect(_on_action_button_pressed.bind("collect"))
func _on_action_button_pressed(action: String) -> void:
	action_chosen.emit(action, target)
