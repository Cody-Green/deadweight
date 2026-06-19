extends Node2D

var grid_thickness = 1
var grid_spacing = 80
var grid_lines = 100
var grid_color = Color(0.0, 0.157, 0.0, 1.0)

func _draw() -> void:
	for i in range(grid_lines + 1):
		# vertical lines
		draw_line(Vector2(i * grid_spacing - grid_lines/2.0 * grid_spacing, -grid_lines/2.0 * grid_spacing),
			Vector2(i * grid_spacing - grid_lines/2.0 * grid_spacing, grid_lines/2.0 * grid_spacing),
			grid_color, grid_thickness, true) 
	for i in range(grid_lines + 1):
		# horizontal lines
		draw_line(Vector2(-grid_lines/2.0 *grid_spacing, i * grid_spacing - grid_lines/2.0 * grid_spacing),
			Vector2(grid_lines/2.0 * grid_spacing, i * grid_spacing - grid_lines/2.0 * grid_spacing),
			grid_color, grid_thickness, true) 
