#Asteroid/CollisionShape.gd
extends CollisionPolygon2D

var shape_vertices : PackedVector2Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	polygon = shape_vertices
