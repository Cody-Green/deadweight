#CollectibleShape.gd

#<->Collectible
#   |->CollectibleShape

extends Node2D

var size : float = 0.0

func _draw() -> void:
	draw_circle(Vector2.ZERO, size, Color(0xff00ffff), true, -1, true)
