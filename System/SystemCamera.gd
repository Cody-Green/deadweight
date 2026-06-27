extends Camera2D

var min_zoom 			:float		= 0.3
var max_zoom 			:float		= 0.8
var zoom_step			:float		= 0.1
var zoom_level			:float		= 0.6
var pan_speed			:float		= 200.0
var pan_direction		:Vector2	= Vector2(0, 0)
func _ready() -> void:
		zoom = Vector2(zoom_level, zoom_level)


func camera_zoom(direction: GameState.ZoomDirection) -> void:
	zoom_level = clamp(zoom_level + zoom_step * direction, min_zoom, max_zoom)
	zoom = Vector2(zoom_level, zoom_level)

func camera_pan(direction: GameState.PanDirection) -> void:
	match direction:
		GameState.direction.UP:
			pan_direction.y += pan_speed * GameState.direction.UP
		GameState.direction.DOWN:
			pan_direction.y += pan_speed * GameState.direction.DOWN
		GameState.direction.LEFT:
			pan_direction.x += pan_speed * GameState.direction.LEFT
		GameState.direction.RIGHT:
			pan_direction.x += pan_speed * GameState.direction.RIGHT
