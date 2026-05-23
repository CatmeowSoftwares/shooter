extends Enemy
var segments: Array[Enemy]
func _ready() -> void:
	speed = 20
	print(Engine.get_license_info().keys())
	super()
	var c_target = self

	for i in range(100):
		var temp = c_target
		c_target = spawn_segment(temp, i)
	spawn_tail(c_target)
	segments.reverse()
func spawn_segment(c_target: Enemy, index: int) -> Enemy:
	var e = preload("uid://bb0l8wf20hrjt").instantiate()
	e.follower = c_target
	var material = StandardMaterial3D.new()
	if index % 2 == 0:
		material.albedo_color = Color(0.283, 0.0, 0.283, 1.0)
	else:
		material.albedo_color = Color(0.18, 0.451, 1.0, 1.0)
	add_sibling(e)
	e.head = self
	e.mesh_instance.material_override = material
	e.global_position = c_target.global_transform * Vector3(0, 0, 1)
	segments.append(e)
	return e
func spawn_tail(c_target: Enemy):
	var e = preload("uid://b4ekbga0ofbd5").instantiate()
	e.head = self
	e.follower = c_target
	add_sibling(e)
	e.global_position = c_target.global_transform * Vector3(0, 0, 1)
	segments.append(e)
	
	
func _on_death():
	for segment in segments:
		if !is_instance_valid(segment):
			continue
		if segment is Enemy:
			segment.death.emit()
		await get_tree().create_timer(0.1).timeout
	queue_free()



func _physics_process(delta: float) -> void:
	#circle_around_player()
	move_toward_player()
	look_at(target.position)
	move_and_slide()



# TODO: fix this
func circle_around_player():
	if velocity.length() < 20:
		velocity += velocity.move_toward(((target.global_transform * Vector3.FORWARD) - global_position).normalized(), speed)
func move_toward_player():
	velocity = ((target.global_transform * Vector3.ZERO) - global_position).normalized() * speed
