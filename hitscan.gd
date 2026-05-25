extends RayCast3D

func _physics_process(delta: float) -> void:
	var last_collision = 0
	while is_colliding():
		var collider = get_collider()
		print("collider is %s" % str(collider))
		var proj = collider.get("projectile")
		if proj:
			proj.hit.emit()
		if collider is Enemy:
			collider.damage(10)
		add_exception(collider)
		last_collision = get_collision_point().length()
		force_raycast_update()
	target_position.z = -last_collision
	queue_free()
