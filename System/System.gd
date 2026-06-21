extends Node2D

var system_collectibles 		:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child_entered_tree.connect(_on_collectible_added)
	child_exiting_tree.connect(_on_collectible_removed)
	
func _process(delta: float) -> void:
	if system_collectibles <= 0 || Input.is_action_just_pressed("system_reset"):
		GameState.player_cargo = 0
		GameState.player_rotation = $Ship.rotation
		get_tree().reload_current_scene()
	
func _on_collectible_added(node) -> void:
	system_collectibles += 1
	print("system_colletible added - system_collectible = ", system_collectibles)

func _on_collectible_removed(node) -> void:
	system_collectibles -= 1
	print("system_colletible removed - system_collectible = ", system_collectibles)
	
