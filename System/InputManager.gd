#InputManager.gd

extends Node2D

signal target_selected(selected_object, global_mouse_position, screen_space_mouse_position)
var selected_object :Object = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_target"):
		var space := get_world_2d().direct_space_state
		var query := PhysicsPointQueryParameters2D.new()
		var global_mouse_position = get_global_mouse_position()
		query.position = global_mouse_position
		query.collision_mask = 0b100
		query.collide_with_areas = true
		query.collide_with_bodies = false
		var result = space.intersect_point(query)
		var target_select_position = global_mouse_position
		var screen_space_position = get_viewport().get_mouse_position()
		if result.size() > 0:
			selected_object = result[0].collider
		else:
			selected_object = null
		target_selected.emit(selected_object, target_select_position, screen_space_position)
