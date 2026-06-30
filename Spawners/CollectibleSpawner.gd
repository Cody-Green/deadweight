#CollectibleSpawner.gd

#<->CollectibleSpawner

extends Node

var collectible 	:= preload("res://Collectible/Collectible.tscn")
var position_min 	:float = -500.0
var position_max 	:float =  500.0
var num_collectibles 	:int   =  20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(num_collectibles):
		var new_collectible = collectible.instantiate()
		new_collectible.add_to_group("collectibles")
		new_collectible.position = Vector2(randf_range(position_min, position_max), randf_range(position_min, position_max))
		get_parent().add_child.call_deferred(new_collectible)
