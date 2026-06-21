#CollectibleShape.gd

#<->Collectible
#   |->CollectibleShape

extends Node2D

func _draw() -> void:
	draw_circle(Vector2.ZERO, 20, Color(0xff00ff67), true, -1, true)
