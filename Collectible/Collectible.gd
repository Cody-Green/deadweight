#Collectible.gd

#<->Collectible

extends Node2D

var mass	:	float
var actions :	Array = [{"text" : "Approach", "id" : "approach"}, {"text" : "Collect", "id" : "collect"}, {"text" : "Orbit", "id" : "orbit"}]
var size	:	float = 10

#Change this if you change the shape of the collectible:
	#For now it works nicely if you change the CollisionCircle radius
var collect_range = size / 2

var ore_chunk_eject_velocity	: Vector2
var ore_chunk_drag				: float = 10 #Majic vaccume drag coeficient becuase game feel > newtonian physics

func _process(delta: float) -> void:
	position += ore_chunk_eject_velocity * delta
	move_toward(position, Vector2.ZERO, ore_chunk_drag)
func _ready() -> void:
	$CollisionArea.area_entered.connect(_on_area_entered)
	$CollisionArea/CollisionCircle.shape.radius = size / 2
	$CollectibleShape.size = size / 2
	
func _on_area_entered(area) -> void:
	if area.is_in_group("player"):
		GameState.update_cargo(mass)
		queue_free()

func get_menu_actions() -> Array:
	return actions
