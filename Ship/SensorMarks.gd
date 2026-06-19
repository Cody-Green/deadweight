extends Node2D

var default_font : Font = ThemeDB.fallback_font
var time := 0.0
var seconds := 0

func _ready() -> void:
	seconds = 1234567890 # limit testing the textbox width and Godot's ~max
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time >= 1.0:
		time -= 1.0
		seconds += 1
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 100, Color(0.180, 0.180, 0.180, 1.0), false, 1, true)
	draw_string(default_font, Vector2(-50, -120), String.num(seconds, 0), HORIZONTAL_ALIGNMENT_CENTER, 100, 16, Color(0.180, 0.180, 0.180, 1.0))
	
