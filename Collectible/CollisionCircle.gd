#Collectible/CollisionCirlce.gd

#|->CollisionArea
#   |->CollisionCircle

extends CollisionShape2D

func _ready() -> void:
	shape = CircleShape2D.new()
	debug_color = Color(0xff00ff67)
