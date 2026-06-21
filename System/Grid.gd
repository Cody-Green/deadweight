#Grid.gd

#<->System
#   |->Grid

extends Node2D

var grid_thickness		:float = 2
var grid_spacing		:int = 100
var grid_lines			:float
var grid_color			:Color = Color(0.0, 0.454, 0.0, 0.15)

func _ready() -> void:
	grid_lines = $GridBackground.grid_scale / grid_spacing

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
