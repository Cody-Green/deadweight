#CollectibleSpawner.gd

#<->CollectibleSpawner

extends Node

var collectible 			:= preload("res://Collectible/Collectible.tscn")
var position_min 			: float 	= -200.0
var position_max 			: float 	=  200.0
var field_position_min 		: float 	= -2000.0
var field_position_max 		: float 	=  2000.0
var field_position			: Vector2 	=  Vector2.ZERO
var num_collectibles 		: int		=  5
var num_fields				: int		=  3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(num_fields):
		seed_field(field_position)
		field_position += Vector2(randf_range(field_position_min, field_position_max), randf_range(field_position_min, field_position_max))
func seed_field(field_position: Vector2) -> void:
	for i in range(num_collectibles):
		var new_collectible = collectible.instantiate()
		new_collectible.add_to_group("collectibles")
		new_collectible.position = field_position + Vector2(randf_range(position_min, position_max), randf_range(position_min, position_max))
		get_parent().add_child.call_deferred(new_collectible)
