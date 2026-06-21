#Hull.gd

#|->Ship
#   |->Hull

extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = [Vector2(32, 0), Vector2(-32, 16), Vector2(-25, 0), Vector2(-32, -16)]
