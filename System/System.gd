#System.gd

extends Node2D

var system_collectibles 		:int
var resetting := false
var current_menu :Control = null
var cursor_menu :PackedScene = preload("res://CursorMenus/CursorMenu.tscn")

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

func _on_new_target(target_object: Object, world_position, screen_space_position: Vector2) -> void:
	if current_menu:
		current_menu.queue_free()
	var new_menu = cursor_menu.instantiate()
	new_menu.position = screen_space_position
	if target_object:
		var entity = target_object.owner # Area2D collider -> Collectible root
		new_menu.target = entity
		new_menu.menu_actions = entity.get_menu_actions()
	else:
		new_menu.menu_actions = $EmptySpace.get_menu_actions()
		# new_menu.target stays null — intended (move_to routes via world_position)
	new_menu.action_chosen.connect(_on_action_chosen.bind(world_position))
	$UICanvasLayer.add_child(new_menu)
	current_menu = new_menu
	
func _on_action_chosen(action: String, target, world_position) -> void:
	var unreachable_message = "UNREACHABLE BRANCH: YOU SHOULDN'T BE SEEING THIS MESSAGE"
	if target:
		match action:
			"approach": $Ship.set_target_position(target.global_position - Vector2(100, 100))
			"collect": $Ship.set_target_position(target.global_position)
			_: print(unreachable_message)
	else:
		match action:
			"move_to": $Ship.set_target_position(world_position)
			_: print(unreachable_message)
	current_menu.queue_free()
	current_menu = null
