#Ship/CollisionCirlce.gd

#|->CollisionArea
#   |->CollisionCircle

extends CollisionShape2D

var circle_radius 		:float = 0.15
var circle_position 	:Vector2 = Vector2(32 - circle_radius, 0)

func _ready() -> void:
	shape = CircleShape2D.new()
	shape.radius = circle_radius
	debug_color = Color(0xff00ff67)
	position = circle_position
