#InputManager.gd

extends Node2D

signal target_selected(selected_object, global_mouse_position, screen_space_mouse_position)
signal zoom_level_changed(zoom_direction)
var selected_object :Object = null
var zoom_direction :Dictionary = {"zoom in" : "in", "zoom out" : "out"}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("target_menu"):
		var space := get_world_2d().direct_space_state
		var query := PhysicsPointQueryParameters2D.new()
		var global_mouse_position = get_global_mouse_position()
		query.position = global_mouse_position
		query.collision_mask = 0b100
		query.collide_with_areas = true
		query.collide_with_bodies = false
		var result = space.intersect_point(query)
		var screen_space_position = get_viewport().get_mouse_position()
		if result.size() > 0:
			selected_object = result[0].collider
		else:
			selected_object = null
		target_selected.emit(selected_object, global_mouse_position, screen_space_position)
	if event.is_action_pressed("zoom_in"):
		zoom_level_changed.emit(zoom_direction.get("zoom in"))
	if event.is_action_pressed("zoom_out"):
		zoom_level_changed.emit(zoom_direction.get("zoom out"))
