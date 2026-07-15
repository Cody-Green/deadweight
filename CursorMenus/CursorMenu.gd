#CursorMenu

#<->CursorMenu

extends PanelContainer

signal action_chosen(action, target)
var target				:Object
var menu_size			:Vector2
var menu_actions		:Array = []
var viewport_rect_size	:Vector2

func _ready() -> void:
	for action in menu_actions:
		var action_button :Button = Button.new()
		action_button.text = action["text"]
		action_button.pressed.connect(_on_action_button_pressed.bind(action["id"]))
		$VBoxContainer.add_child(action_button)
		menu_size = get_combined_minimum_size()
		viewport_rect_size = get_viewport_rect().size

func _on_action_button_pressed(action: String) -> void:
	action_chosen.emit(action, target)
