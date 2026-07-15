#CursorMenu

#<->CursorMenu

extends PanelContainer

signal action_chosen(action, target)
var target				:Object
var menu_size			:Vector2
var menu_actions		:Array = []

func _ready() -> void:
	for action in menu_actions:
		var action_button :Button = Button.new()
		action_button.text = action["text"]
		action_button.pressed.connect(_on_action_button_pressed.bind(action["id"]))
		$VBoxContainer.add_child(action_button)

func _on_action_button_pressed(action: String) -> void:
	action_chosen.emit(action, target)

func get_menu_size() -> Vector2:
	GameState.viewport_rect_size = get_viewport_rect().size
	menu_size = get_combined_minimum_size()
	return menu_size
