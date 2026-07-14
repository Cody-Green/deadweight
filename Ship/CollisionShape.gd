#Ship/CollisionShape.gd

#|->CollisionArea
#   |->CollisionShape

extends CollisionShape2D

func set_collision_shape(front, bottom_left, top_left) -> void:
	shape = ConvexPolygonShape2D.new()
	shape.points = [ front, bottom_left, top_left ]
