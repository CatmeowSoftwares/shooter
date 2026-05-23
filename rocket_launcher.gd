extends Weapon
@onready var marker: Marker3D = $Marker3D

func use(user: Character):
	var rocket = preload("uid://i2vgut0m1lyo").instantiate()
	rocket.transform = marker.global_transform
	get_tree().root.add_child(rocket)
@onready var ray_cast: RayCast3D = $RayCast3D



func alt_use(user: Character):
	while ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider is Character:
			collider.damage(10)
		ray_cast.add_exception(collider)
		ray_cast.force_raycast_update()
