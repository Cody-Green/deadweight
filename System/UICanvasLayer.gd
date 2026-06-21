#UICanvasLayer.gd

#<->System
#   |->UICanvasLayer

extends CanvasLayer

@onready var label = $Label

func _ready() -> void:
	GameState.player_cargo_changed.connect(_on_player_cargo_changed)
	_on_player_cargo_changed(GameState.player_cargo) #instantiate with the player_cargo value in GameState

func _on_player_cargo_changed(amount) -> void:
	label.text = "Cargo: " + String.num(amount, 1) + " kg"
