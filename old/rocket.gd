extends Projectile
@onready var c_body: CharacterBody3D = $CharacterBody3D
@onready var shape_cast: ShapeCast3D = $CharacterBody3D/ShapeCast3D
var pos := Vector3.ZERO

#TODO implement no self harm
func _ready() -> void:
	c_body.position = pos
func _physics_process(delta: float) -> void:
	c_body.velocity = -transform.basis.z * 50
	c_body.move_and_slide()
	var a = c_body.move_and_collide(c_body.velocity)
	if shape_cast.is_colliding():
		var body = shape_cast.get_collider(0)
		if body is Character:
			var dir = position.direction_to(body.global_position)
			#body.knockback(dir * 2)
			body.damage(10)
		explode()
		var collider = shape_cast.get_collider(0)
func _get(property: StringName) -> Variant:
	if property == "position":
		return c_body.position
	if property == "nothing":
		return 0
	return
func _set(property: StringName, value: Variant) -> bool:
	if property == "position":
		pos = value
		if c_body:
			c_body.position = value
		return true
	if property == "transform":
		if c_body:
			c_body.transform = value
	return false
func explode():
	if is_queued_for_deletion():
		return
	var explosion: Explosion = preload("uid://dvywl4dxqer1p").instantiate()
	explosion.position = c_body.global_position
	explosion.radius = 2.0
	get_tree().root.add_child(explosion)
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is StaticBody3D:
		explode()
	elif body is Character:
		var dir = position.direction_to(body.global_position)
		#body.knockback(dir * 2)
		body.damage(10)
		
