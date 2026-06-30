extends Camera2D

var min_zoom 			:float		= 0.3
var max_zoom 			:float		= 0.8
var zoom_step			:float		= 0.1
var zoom_level			:float		= 0.6
var pan_speed			:float		= 600.0

func _ready() -> void:
	if GameState.zoom == Vector2.ZERO:
		zoom = Vector2(zoom_level, zoom_level)
	else:
		zoom = GameState.zoom
		zoom_level = zoom.x

func _process(delta: float) -> void:
	if Input.is_action_pressed("pan_up"):
		position.y -= pan_speed * delta
	if Input.is_action_pressed("pan_left"):
		position.x -= pan_speed * delta
	if Input.is_action_pressed("pan_down"):
		position.y += pan_speed * delta
	if Input.is_action_pressed("pan_right"):
		position.x += pan_speed * delta	

func camera_zoom(direction: GameState.ZoomDirection) -> void:
	zoom_level = clamp(zoom_level + zoom_step * direction, min_zoom, max_zoom)
	zoom = Vector2(zoom_level, zoom_level)
	GameState.zoom = zoom

func center_camera_on_player(player_position: Vector2) -> void:
	position = player_position
