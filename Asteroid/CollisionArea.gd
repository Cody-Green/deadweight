#Asteroid/CollisionArea.gd
extends Area2D

func _ready() -> void:
	assert(collision_layer == 0b101, "Collectible needs layers 1+3: ship pickup + clickable")
