extends Weapon
@onready var marker: Marker3D = $Marker3D


func use(user: Character):
	var hitscan = preload("uid://c6ls04rqunk4o").instantiate()
	hitscan.transform = marker.transform
	add_child(hitscan)
	#if ray_cast.is_colliding():
		#var collider = ray_cast.get_collider()
		#if collider is Character:
			#collider.damage(1)
