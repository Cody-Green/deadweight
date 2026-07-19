#Collectible.gd

#<->Collectible

extends Node2D

var mass	:	float
var actions :	Array = [{"text" : "Approach", "id" : "approach"}, {"text" : "Collect", "id" : "collect"}, {"text" : "Orbit", "id" : "orbit"}]
var size	:	float = 10

# --- debug trail ---
var trail_points : Array[Vector2] = []
const TRAIL_MAX  := 200 
const TRAIL_GAP  := 25

#Change this if you change the shape of the collectible:
	#For now it works nicely if you change the CollisionCircle radius
var collect_range = size / 2

var velocity	: Vector2
var drag		: float = 35 #Magic vaccume drag coeficient becuase game feel > newtonian physics

func _ready() -> void:
	$CollisionArea.area_entered.connect(_on_area_entered)
	$CollisionArea/CollisionCircle.shape.radius = size / 2
	$CollectibleShape.size = size / 2

func _process(delta: float) -> void:
	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, drag * delta)

	if GameState.debug:
		if trail_points.is_empty() or global_position.distance_to(trail_points[-1]) >= TRAIL_GAP:
			trail_points.append(global_position)
			if trail_points.size() > TRAIL_MAX:
				trail_points.pop_front()
		queue_redraw()

func _on_area_entered(area) -> void:
	pass
	#commented out for now so the ship doesn't eat the collecitbles; probably going to be handled by the tractor beam logic 
	#if area.is_in_group("player"):
		#GameState.update_cargo(mass)
		#queue_free()

func get_menu_actions() -> Array:
	return actions


func _draw() -> void:
	if not GameState.debug or trail_points.size() < 2:
		return
	var pts : PackedVector2Array = []
	for p in trail_points:
		pts.append(to_local(p))
	draw_polyline(pts, Color(0.365, 0.949, 0.305, 0.6), 2.0, true)
	for lp in pts:
		draw_circle(lp, 2.0, Color(0.996, 0.627, 0.569, 0.851))
