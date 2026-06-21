#ShipUI.gd

#|->Ship
#   |->ShipUI
extends Node2D

var default_font 	:Font = ThemeDB.fallback_font

func _draw() -> void:
	pass
	#draw_circle(Vector2.ZERO, 100, Color(0x6a6a6aff), false, 1, true)
	#draw_line(Vector2(0, -90), Vector2(0, -110), Color(0x6a6a6aff), 2, true)
	#draw_string(default_font, Vector2(-250, -120), "Cargo: " + String.num(cargo_mass, 1) + " kg", HORIZONTAL_ALIGNMENT_CENTER, 500, 30, Color(0x6a6a6aff))
	#keeping these for the color values when move the UI to the UICanvasLayer later
