#Hull.gd

#<->Ship
#   |->Hull

extends Polygon2D


func set_hull(length, width, notch_scale) -> void:
	polygon = [Vector2(0, 0), Vector2(-length, width), Vector2(-length + (length * notch_scale), 0), Vector2(-length, -width)]
