extends RigidBody3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var area_collision_shape: CollisionShape3D = $Area3D/CollisionShape3D

var weapon: Weapon
func _ready() -> void:
	print(get_children())
	var meshes = find_children("*", "MeshInstance3D", true, false)
	print("aaa")
	print(meshes.is_empty())
	var meshinstance = MeshInstance3D.new()
	var meshh = BoxMesh.new()
	var aabb = AABB()
	for mesh in meshes:
		var maabb = mesh.mesh.get_aabb()
		print("aaaa  " + str(maabb))
		aabb.position += maabb.position
		aabb.size += maabb.size
	meshh.size = aabb.size
	meshinstance.mesh = meshh
	var shape = collision_shape.shape
	if shape is BoxShape3D:
		shape.size = aabb.size
		collision_shape.position = aabb.get_center()
	var area_shape = area_collision_shape.shape
	if area_shape is BoxShape3D:
		area_shape.size = aabb.size * 1.01
		area_collision_shape.position = aabb.get_center()
	meshinstance.position = aabb.get_center()
	
	add_child(meshinstance)
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		weapon.reparent(body.hand, false)
		body.current_weapon = weapon
		queue_free()
