#Asteroid/CollisionArea.gd
extends Area2D

func _ready() -> void:
	collision_layer = 0b101 #Layer 1 and 3
