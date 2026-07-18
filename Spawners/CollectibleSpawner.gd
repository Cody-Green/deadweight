#CollectibleSpawner.gd

#<->CollectibleSpawner

extends Node

var collectible 			:= preload("res://Collectible/Collectible.tscn")
var position_min 			: float 	= -20.0
var position_max 			: float 	=  20.0
var field_position_min 		: float 	= -2000.0
var field_position_max 		: float 	=  2000.0
var field_position			: Vector2 	=  Vector2.ZERO
var num_collectibles 		: int		=  3
var num_fields				: int		=  3

func _ready() -> void:
	pass
	#for i in range(num_fields):
		#seed_field(field_position)
		#field_position += Vector2(randf_range(field_position_min, field_position_max), randf_range(field_position_min, field_position_max))

#func seed_field(_field_position: Vector2) -> void:
	#for i in range(num_collectibles):
		#var new_collectible = collectible.instantiate()
		#new_collectible.add_to_group("collectibles")
		#new_collectible.position = _field_position + Vector2(randf_range(position_min, position_max), randf_range(position_min, position_max))
		#get_parent().get_parent().add_child.call_deferred(new_collectible)

func spawn_collectible() -> void:
	var new_collectible = collectible.instantiate()
	new_collectible.add_to_group("collectibles")
	new_collectible.position = Vector2(randf_range(10, position_max), randf_range(10, position_max))
	get_parent().get_parent().add_child.call_deferred(new_collectible)
