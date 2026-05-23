class_name Explosion extends AreaEffect
@onready var area: Area3D = $Area3D
@onready var collision_shape: CollisionShape3D = $Area3D/CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var mesh_instance_inner: MeshInstance3D = $MeshInstance3D2

@onready var timer: Timer = $Timer
@onready var omni_light: OmniLight3D = $OmniLight3D

var damage: int = 1.0
var radius: float = 0.0
var lifetime = 1.0

func _ready() -> void:
	var tween = create_tween()
	var shape = collision_shape.shape
	var mesh = mesh_instance.mesh

	tween.parallel().tween_property(shape, "radius", radius, 0.1)
	tween.parallel().tween_property(mesh_instance_inner.mesh, "radius", radius*0.75, 0.1)
	tween.parallel().tween_property(mesh_instance_inner.mesh, "height", (radius*2)*0.75, 0.1)
	tween.parallel().tween_property(mesh, "radius", radius, 0.1)
	tween.parallel().tween_property(mesh, "height", radius*2, 0.1)
	tween.parallel().tween_property(omni_light, "omni_range", radius, 0.1)
	if mesh is SphereMesh:
		var a = mesh_instance.material_override
		if a:
			tween.tween_callback(area.queue_free)
			#tween.tween_callback(_sq)
			tween.parallel().tween_property(a, "albedo_color", Color(0.0, 0.0, 0.0, 0.0), 0.5)
			tween.parallel().tween_property(mesh_instance_inner.material_override, "albedo_color", Color(0.0, 0.0, 0.0, 0.0), 0.5)
			tween.parallel().tween_property(omni_light, "light_energy", 0.0, 0.5)
	timer.wait_time = lifetime
	timer.start()
	
func _sq():
	var aabb = mesh_instance.mesh.get_aabb()
	var m = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = aabb.size
	m.position = aabb.get_center()
	m.mesh = box
	add_child(m)
func _on_area_3d_body_entered(body: Node3D) -> void:
	var dir = position.direction_to(body.global_position)
	var dist = position.distance_squared_to(body.global_position)
	var power = 10.0

	dir.y /= 2.0
	var force = (1.0/dist * power) * dir
	if body is Character:
		if not body.is_on_floor():
			power *= 2.0
			force = (1.0/dist * power) * dir
		body.knockback(force)
		body.damage(damage)
	elif body is RigidBody3D:
		body.apply_impulse(force)
	
func _on_timer_timeout() -> void:
	queue_free()
