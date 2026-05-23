extends Weapon
@onready var ray_cast: RayCast3D = $RayCast3D



func use(user: Character):
	while ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider is Character:
			collider.damage(10)
		ray_cast.add_exception(collider)
		ray_cast.force_raycast_update()
