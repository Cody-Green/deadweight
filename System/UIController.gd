#UICanvasLayer.gd

#<->System
#   |->UICanvasLayer

extends CanvasLayer

var player_ship : Node2D
@onready var label = $ShipCargoLabel

func _ready() -> void:
	GameState.player_cargo_changed.connect(_on_player_cargo_changed)
	_on_player_cargo_changed(GameState.player_cargo) #instantiate with the player_cargo value in GameState

func _process(delta: float) -> void:
	if player_ship:
		label.position = player_ship.get_global_transform_with_canvas().origin + Vector2(-label.size.x / 2.0, -60)

func _on_player_cargo_changed(amount) -> void:
	label.text = "Cargo: " + String.num(amount, 1) + " kg"
