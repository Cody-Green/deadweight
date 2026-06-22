#Collectible/CollisionCirlce.gd

#|->CollisionArea
#   |->CollisionCircle

extends CollisionShape2D

func _ready() -> void:
	shape = CircleShape2D.new()
	shape.radius = 20
	debug_color = Color(0x4ec9b0ff)
