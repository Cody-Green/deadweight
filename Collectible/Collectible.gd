#CollectibleCollision.gd

#|->Collectible
#   |->CollisionArea

extends Node2D

var mass :float

func _ready() -> void:
	$CollisionArea.area_entered.connect(_on_area_entered)
	mass = randf_range(5.0, 50.0)
	
func _on_area_entered(_area) -> void:
	GameState.update_cargo(mass)
	queue_free()
