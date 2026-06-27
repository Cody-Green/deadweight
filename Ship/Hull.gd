#Hull.gd

#<->Ship
#   |->Hull

extends Polygon2D
var hull_length :float = 64.0
var hull_width :float = 32.0
var notch_scale :float = 0.28

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = [Vector2(hull_length/2, 0), Vector2(-hull_length/2, hull_width/2), Vector2(-hull_length * notch_scale, 0), Vector2(-hull_length/2, -hull_width/2)]
