#GridBackground.gd

# |->Grid
#    |->GridBackground

extends Polygon2D

var grid_scale		:float = 60000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = [Vector2(-grid_scale/2, -grid_scale/2), Vector2(grid_scale/2, -grid_scale/2), Vector2(grid_scale/2, grid_scale/2), Vector2(-grid_scale/2, grid_scale/2)]
