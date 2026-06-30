#Collectible.gd

#<->Collectible

extends Node2D

var mass :float
var actions :Array = [{"text" : "Approach", "id" : "approach"}, {"text" : "Collect", "id" : "collect"}, {"text" : "Orbit", "id" : "orbit"}]
var size :Vector2 = Vector2(1, 1) * 60

#Change this if you change the shape of the collectible:
	#For now it works nicely if you change the CollisionCircle radius
var collect_range = size.x / 2

func _ready() -> void:
	$CollisionArea.area_entered.connect(_on_area_entered)
	$CollisionArea/CollisionCircle.shape.radius = size.x / 2
	mass = randf_range(5.0, 50.0)
	
func _on_area_entered(area) -> void:
	if area.is_in_group("player"):
		GameState.update_cargo(mass)
		queue_free()

func get_menu_actions() -> Array:
	return actions
