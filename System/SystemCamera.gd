extends Camera2D

var min_zoom 			:float = 0.3
var max_zoom 			:float = 0.8
var zoom_step			:float = 0.1
var zoom_level			:float = 0.6

func _ready() -> void:
		zoom = Vector2(zoom_level, zoom_level)


func camera_zoom(direction: GameState.ZoomDirection) -> void:
	zoom_level = clamp(zoom_level + zoom_step * direction, min_zoom, max_zoom)
	zoom = Vector2(zoom_level, zoom_level)
