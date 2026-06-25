#CollectibleShape.gd

#<->Collectible
#   |->CollectibleShape

extends Node2D

func _draw() -> void:
	draw_circle(Vector2.ZERO, 20, Color(0x4ec9b01e), true, -1, true)
	draw_line(Vector2(-20, 0), Vector2(20, 0), Color(0xb800903c), 1, true)
	draw_line(Vector2(0, -20), Vector2(0, 20), Color(0xb800903c), 1, true)
