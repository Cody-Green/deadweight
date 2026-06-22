#UICanvasLabel.gd

#|->UICanvasLayer
#   |->UICanvasLabel

extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	position = Vector2(get_viewport_rect().size/2 - size + Vector2(0, -50))
