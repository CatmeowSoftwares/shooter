extends Weapon
@onready var ray_cast: RayCast3D = $RayCast3D

@onready var shape_cast: ShapeCast3D = $ShapeCast3D
# either use shapecast or area3d
func use(user: Character):
	while shape_cast.is_colliding():
		for i in range(shape_cast.get_collision_count()):
			var collider = shape_cast.get_collider(i)
			if collider is Enemy:
				collider.kill()
				shape_cast.add_exception(collider)
		shape_cast.force_shapecast_update()
