#InputManager.gd

extends Node2D

signal target_selected(selected_object, global_mouse_position)
var selected_object :Object = null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select_target"):
		var space := get_world_2d().direct_space_state
		var query := PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collision_mask = 0b100
		query.collide_with_areas = true
		query.collide_with_bodies = false
		var result = space.intersect_point(query)
		var target_select_position = get_global_mouse_position()
		if result.size() > 0:
			selected_object = result[0].collider
		else:
			selected_object = null
		target_selected.emit(selected_object, target_select_position)
