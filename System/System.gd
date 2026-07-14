#System.gd

extends Node2D

var resetting := false
var current_menu :Control = null
var cursor_menu :PackedScene = preload("res://CursorMenus/CursorMenu.tscn")

func _ready() -> void:
	$UIController.player_ship = $Ship
	$InputManager.target_selected.connect(_on_new_target)
	$InputManager.zoom_level_changed.connect(_on_camera_zoom)
	$InputManager.camera_reset_selected.connect(_on_camera_reset)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("system_reset"):
		system_reset($Ship.rotation, $Ship.global_position, $SystemCamera.zoom, 0)

func _on_camera_reset() -> void:
	$SystemCamera.center_camera_on_player($Ship.global_position)

func _on_collectible_removed(_node) -> void:
	if not is_inside_tree():
		return

func system_reset(set_ship_rotation: float, set_ship_position: Vector2, set_zoom: Vector2, set_ship_cargo: int) -> void:
	if resetting:
		return
	resetting = true
	GameState.player_cargo = set_ship_cargo
	GameState.zoom = set_zoom
	GameState.player_rotation = set_ship_rotation
	GameState.player_position = set_ship_position
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
	$UIController.add_child(new_menu)
	current_menu = new_menu
	
func _on_action_chosen(action: String, target, world_position) -> void:
	var unreachable_message = "UNREACHABLE BRANCH: YOU SHOULDN'T BE SEEING THIS MESSAGE"
	if target:
		var direction_to_target = target.global_position - $Ship.global_position
		match action:
			"approach": $Ship.set_target_position(
				$Ship.global_position +
				direction_to_target.normalized() * 
				(direction_to_target.length() - 100)) #Temporary: arbitrary approach distance
			"collect": $Ship.set_target_position(
				$Ship.global_position +
				direction_to_target.normalized() * 
				(direction_to_target.length() - target.collect_range))
			"orbit": $Ship.set_orbit(target.global_position)
			"mine":
				if $Ship.global_position.distance_to(target.global_position) > 110: #Temporary: distance just outside of temp approach distance
					print("Out of mining range")
				else:
					print("Mining the asteroid")
					target.extract_ore_chunk()
			_: print(unreachable_message)
	else: #The user has selected empty space
		match action:
			"move_to": $Ship.set_target_position(world_position)
			_: print(unreachable_message)

	current_menu.queue_free()
	current_menu = null

func _on_camera_zoom(direction: GameState.ZoomDirection) -> void:
	$SystemCamera.camera_zoom(direction)

func _draw() -> void:
	if GameState.debug:
		pass
