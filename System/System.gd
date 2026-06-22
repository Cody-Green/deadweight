#System.gd

extends Node2D

var system_collectibles 		:int
var resetting := false

func _ready() -> void:
	child_entered_tree.connect(_on_collectible_added)
	child_exiting_tree.connect(_on_collectible_removed)
	$InputManager.target_selected.connect(_on_new_target)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("system_reset"):
		print("q pressed -> triggers reset")
		system_reset($Ship.rotation, 0)
	
func _on_collectible_added(node) -> void:
	if node.is_in_group("collectibles"):
		print("system_colletible added - system_collectible = ", system_collectibles)
		system_collectibles += 1

func _on_collectible_removed(node) -> void:
	if not is_inside_tree():
		return
	if node.is_in_group("collectibles"):
		system_collectibles -= 1
		print("system_colletible removed - system_collectible = ", system_collectibles)
		if system_collectibles <= 0 and not resetting:
			print("last collectible collected -> triggers reset")
			system_reset($Ship.rotation, 0)
	
func system_reset(set_ship_rotation: float, set_ship_cargo: int) -> void:
	print(">>> system_reset called, resetting=", resetting, " count=", system_collectibles)
	if resetting:
		print(">>> guard caught re-entry")
		return
	resetting = true
	GameState.player_cargo = set_ship_cargo
	GameState.player_rotation = set_ship_rotation
	get_tree().reload_current_scene.call_deferred()

func _on_new_target(target_object: Object, null_position: Vector2) -> void:
	if target_object:
		$Ship.set_target_position(target_object.global_position) #eventually routes to UIManager
	else:
		$Ship.set_target_position(null_position)
