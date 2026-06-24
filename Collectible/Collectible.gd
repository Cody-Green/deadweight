#Collectible.gd

#<->Collectible

extends Node2D

var mass :float
var actions :Array = [{"text" : "Approach", "id" : "approach"}, {"text" : "Collect", "id" : "collect"}]
func _ready() -> void:
	$CollisionArea.area_entered.connect(_on_area_entered)
	mass = randf_range(5.0, 50.0)
	
func _on_area_entered(area) -> void:
	if area.is_in_group("player"):
		print(">>> collected, mass=", mass) 
		GameState.update_cargo(mass)
		queue_free()

func get_menu_actions() -> Array:
	return actions
